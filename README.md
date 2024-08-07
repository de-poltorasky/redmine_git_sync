# Redmine Git Sync Plugin

## Description

Le plugin **Redmine Git Sync** permet de synchroniser des répertoires Git en utilisant une clé API pour l'authentification. Chaque projet peut être synchronisé dans un répertoire dédié, facilitant ainsi la gestion des dépôts Git depuis l'interface de Redmine.

## Installation

1. Clonez ce dépôt dans le répertoire `plugins` de votre installation Redmine :
   ```sh
   cd redmine/plugins
   git clone https://github.com/de-poltorasky/redmine_git_sync.git

2. Redémarrez votre serveur Redmine pour que le plugin soit pris en compte.

## Configuration
Accédez à l'administration de Redmine et activez les permissions pour les rôles appropriés :
View Git Sync : Pour afficher l'onglet Git Sync dans les projets.
Sync Git Repositories : Pour synchroniser les répertoires Git.

## Utilisation
Accédez à un projet dans Redmine.

Cliquez sur l'onglet Git Sync.

Remplissez les champs nécessaires :

- Source Repository : URL du dépôt Git source.
- API Key : Clé API pour l'authentification.
- Project Name : Nom du projet pour créer un répertoire dédié.

Cliquez sur Sync pour lancer la synchronisation.


## Licence
Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.
