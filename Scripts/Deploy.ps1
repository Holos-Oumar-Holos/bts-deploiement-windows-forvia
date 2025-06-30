# =================================================================
# SCRIPT POWERSHELL - DÉPLOIEMENT AUTOMATISÉ POSTE UTILISATEUR
# =================================================================

param(
    [switch]$NuclearMode = $true,               
    [string]$ChocoSource = "https://community.chocolatey.org/api/v2/"
)

# FONCTIONS CORRIGÉES
function Remove-BloatwareSecure {
    param([string[]]$PackageList)

    $removed = @()
    $failed  = @()
    $total   = $PackageList.Count
    $current = 0

    Write-Host "[NUCLEAR MODE] Suppression de $total packages..." -ForegroundColor Red

    foreach ($package in $PackageList) {
        $current++
        $pct = [math]::Round(($current / $total) * 100)

        try {
            # Recherche des apps installées
            $inst = Get-AppxPackage -Name $package -AllUsers -ErrorAction SilentlyContinue
            
            # Recherche du provisioning
            $prov = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -EQ $package

            if ($inst) {
                Write-Host "[$pct%] Suppression: $package" -ForegroundColor Yellow
                $inst | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                $removed += $package
            }

            if ($prov) {
                Write-Host "[$pct%] Suppression provisioned: $package" -ForegroundColor Yellow
                Remove-AppxProvisionedPackage -Online -PackageName $prov.PackageName -ErrorAction SilentlyContinue
            }

            if (-not $inst -and -not $prov) {
                Write-Host "[$pct%] Non installe: $package" -ForegroundColor DarkGray
            }
        }
        catch {
            Write-Warning "[$pct%] Echec: $package - $($_.Exception.Message)"
            $failed += $package
        }
    }

    # Reporting final
    Write-Host "`n[RESULTATS]" -ForegroundColor Green
    Write-Host "Supprimes: $($removed.Count)" -ForegroundColor Green
    Write-Host "Echecs: $($failed.Count)" -ForegroundColor Red
    if ($failed.Count -gt 0) {
        Write-Host "Packages echoues: $($failed -join ', ')" -ForegroundColor Red
    }
}

function Install-PackageRobuste {
    param([string]$Name, [int]$MaxAttempts = 2)

    for ($i = 1; $i -le $MaxAttempts; $i++) {
        try {
            choco install $Name -y --source=$ChocoSource
            Write-Host "Installation de $Name reussie (tentative $i)." -ForegroundColor Green
            return $true
        }
        catch {
            Write-Warning "Echec $Name (tentative $i) : $_"
            Start-Sleep -Seconds 3
        }
    }

    # Forçage via Chocolatey
    try {
        choco upgrade $Name --force -y --source=$ChocoSource
        Write-Host "$Name installe par forçage." -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "Impossible d'installer $Name : $_"
        return $false
    }
}

# 1. VÉRIFICATIONS PRÉLIMINAIRES
If (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Write-Warning "Execution requise en mode administrateur."
    Exit 1
}

$freeGB = (Get-PSDrive C).Free / 1GB
if ($freeGB -lt 10) {
    Write-Error "Moins de 10 Go libres sur C:, arret du script."
    Exit 1
}

$os  = Get-CimInstance Win32_OperatingSystem
$ver = $os.Version
Write-Host "Version Windows detectee : $ver" -ForegroundColor Yellow

# CORRECTION CRITIQUE : Expression régulière simplifiée
if ($ver -notmatch '^10\.|^11\.') {
    Write-Error "Version Windows non supportee ($ver)."
    Exit 1
}

# 2. JOURNALISATION
$logDir  = 'C:\Logs'
$logPath = "$logDir\Deploy_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
if (-not (Test-Path $logDir)) { 
    New-Item -Path $logDir -ItemType Directory -Force | Out-Null 
}
Start-Transcript -Path $logPath -Append
Write-Host "[START] Demarrage du deploiement..." -ForegroundColor Green

# 3. CONFIGURATION SÉCURITÉ MINIMALE
try {
    Write-Host "[SECURITE] Renforcement systeme..." -ForegroundColor Yellow
    
    # Désactiver SMBv1
    if ((Get-SmbServerConfiguration).EnableSMB1Protocol) {
        Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force -Confirm:$false
    }
}
catch {
    Write-Warning "[ERREUR SECURITE] $_"
}

# 4. PRÉREQUIS RÉSEAU
if (-not (Test-NetConnection -ComputerName 'community.chocolatey.org' -Port 443 -InformationLevel Quiet)) {
    Write-Error "Connectivite reseau insuffisante vers Chocolatey.org"
    Exit 1
}

# 5. INSTALLATION CHOCOLATEY
try {
    Write-Host "[CHOCOLATEY] Installation..." -ForegroundColor Yellow
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        iex ((New-Object System.Net.WebClient).DownloadString(
            'https://community.chocolatey.org/install.ps1'))
        if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
            throw 'Echec installation Chocolatey'
        }
    }
    choco feature disable -n showDownloadProgress -y
    Write-Host "[OK] Chocolatey pret." -ForegroundColor Green
}
catch {
    Write-Error "[CRITIQUE] Chocolatey : $_"
    Stop-Transcript
    Exit 1
}

# 6. DÉBLOATAGE (OPTIONNEL)
if ($NuclearMode) {
    Write-Host '[DEBLOAT] Suppression des applications inutiles…' -ForegroundColor Magenta

    $BloatwareList = @(
        'Microsoft.3DBuilder',
        'Microsoft.549981C3F5F10',
        'Microsoft.BingFinance',
        'Microsoft.MicrosoftSolitaireCollection',
        'Microsoft.XboxApp',
        'king.com.CandyCrushSaga',
        'Facebook.Facebook',
        'SpotifyAB.SpotifyMusic',
        'HP.HPJumpStart',
        'Microsoft.YourPhone',
        'Microsoft.WindowsCamera',
	'MicrosoftWindows.CrossDevice',
	'Microsoft.BingSearch'
    )

    Remove-BloatwareSecure -PackageList $BloatwareList
}

# 7. INSTALLATION DES LOGICIELS 
$apps    = @('googlechrome','vlc','7zip','libreoffice-fresh','notepadplusplus')
$success = @()
$fail    = @()

foreach ($app in $apps) {
    if (-not (choco list --local-only | Select-String -Pattern "^$app ")) {
        Write-Host "[INSTALL] $app" -ForegroundColor Cyan
        if (Install-PackageRobuste -Name $app) { 
            $success += $app 
        }
        else { 
            $fail += $app 
        }
    } else {
        Write-Host "[SKIP] $app deja installe" -ForegroundColor DarkGray
        $success += $app
    }
}

# Installation Chrome Enterprise
try {
    Write-Host "[CHROME] Installation version Enterprise" -ForegroundColor Cyan
    Invoke-WebRequest -Uri "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" -OutFile "$env:TEMP\chrome.msi"
    Start-Process msiexec.exe -Args "/i `"$env:TEMP\chrome.msi`" /qn /norestart" -Wait
    Remove-Item "$env:TEMP\chrome.msi"
}
catch {
    Write-Warning "Erreur installation Chrome Enterprise : $_"
}

# 8. LOCALE & FUSEAU HORAIRE
Set-WinSystemLocale fr-FR
$fzt = 'W. Europe Standard Time'
if (Get-TimeZone -ListAvailable | Where-Object Id -EQ $fzt) {
    Set-TimeZone -Id $fzt
    Write-Host "Fuseau horaire defini sur $fzt" -ForegroundColor Green
} else {
    Write-Warning "Fuseau horaire $fzt introuvable ; configuration conservee."
}

# 9. FINALISATION
Write-Host "`n[RESUME] Apps OK    : $($success -join ', ')" -ForegroundColor Cyan
if ($fail.Count -gt 0) {
    Write-Host "[RESUME] Apps echouees: $($fail -join ', ')" -ForegroundColor Red
}

$needRestart = $success.Count -gt 0
Write-Host "Redemarrage requis : $needRestart" -ForegroundColor Yellow

if ($needRestart) {
    Write-Host "Redemarrage dans 30s (Ctrl+C pour annuler)..." -ForegroundColor Yellow
    Start-Sleep 30
    Restart-Computer -Force
} else {
    Write-Host "Pas de redemarrage necessaire." -ForegroundColor Green
}

Stop-Transcript
