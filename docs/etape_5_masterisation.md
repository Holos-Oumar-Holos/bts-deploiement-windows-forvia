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
  
---
![000a](https://github.com/user-attachments/assets/71f1272b-0d31-4707-a8b8-7694e0a25144)
![000b](https://github.com/user-attachments/assets/488e06e3-fad8-43fe-ab34-2eb7f774fee9)
![004](https://github.com/user-attachments/assets/73c0e02c-120b-4aa0-abe4-50c614800e9e)
![005](https://github.com/user-attachments/assets/383d1780-9981-4a74-8927-44479a5ceecd)
![006](https://github.com/user-attachments/assets/41c36cfc-6952-4f17-b512-a545cc2f33ae)
![007](https://github.com/user-attachments/assets/68f72335-6ee4-4d93-977e-60817392848f)
![008](https://github.com/user-attachments/assets/90f76d33-2a48-4c28-b252-6bf1c5cf71ef)
![009](https://github.com/user-attachments/assets/aee28ba0-8241-4ecb-a4f2-2965334831fc)
![010](https://github.com/user-attachments/assets/7ac05d3c-743f-4c76-8c2e-bfe2612eecf8)
![011](https://github.com/user-attachments/assets/e44f943a-a30f-4e8e-9989-2391d09d86ce)
![012](https://github.com/user-attachments/assets/110837dc-4672-45a8-8133-42192f6506a3)
![013](https://github.com/user-attachments/assets/483fcc25-bd0d-4dee-ba95-e2ac6dd3c996)
![014](https://github.com/user-attachments/assets/429ab28b-c1b5-405f-90b9-9f19eb3ea85a)
