# Redmine Git Sync Plugin

## Description

Le plugin **Redmine Git Sync** permet de synchroniser des répertoires Git en utilisant une clé API pour l'authentification. Chaque projet peut être synchronisé dans un répertoire dédié, facilitant ainsi la gestion des dépôts Git depuis l'interface de Redmine.

## Installation

1. Clonez ce dépôt dans le répertoire `plugins` de votre installation Redmine :
   ```sh
   cd redmine/plugins
   git clone https://github.com/votre-utilisateur/redmine_git_sync.git
``

2. Redémarrez votre serveur Redmine pour que le plugin soit pris en compte.

##Configuration
Accédez à l'administration de Redmine et activez les permissions pour les rôles appropriés :
View Git Sync : Pour afficher l'onglet Git Sync dans les projets.
Sync Git Repositories : Pour synchroniser les répertoires Git.
Utilisation
Accédez à un projet dans Redmine.

Cliquez sur l'onglet Git Sync.

Remplissez les champs nécessaires :

Source Repository : URL du dépôt Git source.
Target Repository : URL du dépôt Git cible.
API Key : Clé API pour l'authentification.
Project Name : Nom du projet pour créer un répertoire dédié.
Cliquez sur Sync pour lancer la synchronisation.

```sh
redmine_git_sync/
├── init.rb
├── app/
│   ├── controllers/
│   │   └── git_sync_controller.rb
│   ├── models/
│   └── views/
│       └── git_sync/
│           └── index.html.erb
├── config/
│   └── routes.rb
├── lib/
│   └── tasks/
│       └── git_sync.rake
└── assets/
````

##Contribuer
Forkez ce dépôt.
Créez une branche pour votre fonctionnalité (git checkout -b feature/new-feature).
Commitez vos modifications (git commit -am 'Add new feature').
Poussez votre branche (git push origin feature/new-feature).
Créez une Pull Request.
##Licence
Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

### Note:
- Remplacez `https://github.com/votre-utilisateur/redmine_git_sync.git` par l'URL réelle de votre dépôt.
- Assurez-vous que tous les chemins et fichiers mentionnés dans le README existent bien dans la structure de votre plugin.
