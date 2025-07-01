# **Étape 5 : **

- J’ai lancé WinPE dans la VM pour travailler sur l’image système.
    
- Windows est installé sur la partition 1 (C:), la partition 2 (D:) est dédiée aux données.
    
- Mon but était de déposer l’image sur la partition D:, mais la commande utilisée (`BCDBOOT C:\Windows /S C:`) fait référence à C:\install.wim. Cette différence peut venir d’une variante de configuration ou d’une coquille, mais reste techniquement possible selon le contexte.
    
- J’ai modifié les paramètres de la VM (firmware BIOS/UEFI ou gestionnaire de démarrage) pour pouvoir choisir de démarrer soit sur WinPE, soit sur Windows 10.
    
- Ça a permis de basculer sur WinPE, et j’ai aussi modifié le fichier `.vmx` de la VM pour forcer le démarrage sur WinPE, et éviter de démarrer directement sur le disque dur Windows.
    
- Après la configuration, j’ai redémarré Windows normalement.
    
- J’ai localisé l’image install,wim dans la partition visée.
    
- Je l’ai transférée sur mon PC via le dossier partagé entre la VM et la machine hôte.
    
- Ensuite, j’ai pris une ISO Windows vierge, extrait son contenu, puis remplacé le fichier `install,wim` dans le dossier `sources` par celui que j’avais créé.
	
- À ce stade, la VM n’a pas encore été testée avec cette nouvelle ISO.


![alt text](000b.png) ![alt text](004-2.png) ![alt text](005-2.png) ![alt text](006-2.png) ![alt text](007-2.png) ![alt text](008-2.png) ![alt text](009-2.png) ![alt text](010-2.png) ![alt text](011-2.png) ![alt text](012-2.png) ![alt text](013-2.png) ![alt text](014-2.png) ![alt text](000a.png)