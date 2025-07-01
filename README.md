<!-- README.md -->

# 🚀 Déploiement Windows automatisé – Projet BTS SIO

![PowerShell](https://img.shields.io/badge/PowerShell-v5.1%2B-blue)
![Chocolatey](https://img.shields.io/badge/Chocolatey-vlatest-red)
![Sysprep](https://img.shields.io/badge/Sysprep-enabled-brightgreen)

---

## 1. Introduction
Ce projet automatise l’installation et la configuration d’un poste Windows 10.
Il utilise **PowerShell**, **Chocolatey** et **Sysprep** pour créer un master clonable.

---

## 2. Environnement
- **VMware Workstation** (UEFI)  
- **ISO** officielle Windows 10/11 Pro  
- **PowerShell** 5.1+ et **Chocolatey**  
- Dossier partagé hôte ↔ VM pour scripts  
- Outil **Sysprep** intégré à Windows

---

## 3. Script PowerShell (`deploy.ps1`)
1. **Vérifications préliminaires**  
   - Droits administrateur  
   - Espace libre ≥ 10 Go  
   - Version Windows 10/11  
2. **Installation Chocolatey**  
   - Téléchargement  
   - Configuration et mise à jour  
3. **Installation logicielle**  
   - Chrome, VLC, 7‑Zip, LibreOffice, Notepad++  
4. **Débloat**  
   - Suppression de OneDrive, Cortana, Xbox, CandyCrush  
5. **Configuration système**  
   - Langue `fr-FR`  
   - Fuseau horaire Europe de l’Ouest  
6. **Journalisation**  
   - `Start-Transcript` vers `C:\Logs`  
7. **Résumé et reboot**  
   - Liste des applis installées  
   - Redémarrage automatique

---

## 4. Masterisation avec Sysprep
1. Exécuter :  
   ```powershell
   C:\Windows\System32\Sysprep\sysprep.exe
   
![lessgoo](https://github.com/user-attachments/assets/71e63ae0-39a8-4825-927d-1b3b4523a7e2)



---
