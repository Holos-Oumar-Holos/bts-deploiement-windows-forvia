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


![[004 1.png]]![[005 1.png]]![[006 1.png]]![[007 1.png]]![[008 1.png]]![[009 1.png]]![[010 1.png]]![[011 1.png]]![[012 1.png]]![[013 1.png]]![[014 1.png]]