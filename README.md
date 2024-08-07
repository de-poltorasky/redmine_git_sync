# Redmine Git Sync Plugin

This Redmine plugin enables synchronization of Git repositories with Redmine projects. It allows users to clone or update Git repositories directly into the Redmine environment.

## Features

- Clone Git repositories using HTTPS and API key authentication.
- Update existing repositories with the latest changes.
- Provid information to configure built-in Git SCM feature 

## Installation

1. **Clone the repository**:
   ```sh
   cd /path/to/redmine/plugins
   git clone https://github.com/yourusername/redmine_git_sync.git
   bundle install
   bundle exec rake redmine:plugins:migrate RAILS_ENV=production
   sudo systemctl restart redmine

## Usage
Navigate to the project in Redmine.
- Configure the permission </br>
 ![image](https://github.com/user-attachments/assets/d1e16edf-f167-4cd3-8acb-59da700bceb5)
- Enable the Plugin within the project </br>
 ![image](https://github.com/user-attachments/assets/5ceef2f8-90b6-495f-9471-c395c3580208)

- Go to the "Git Sync" tab.
- Enter the source repository URL, API key, and other options.
- Click "Sync" to clone or update the repository.

![image](https://github.com/user-attachments/assets/65ffd1c8-2542-4ed1-9b7f-53953e5b0832)


## Configuration
- Source Repository: The URL of the Git repository to synchronize.
- API Key: Your Git provider's API key for authentication.
- Skip SSL Verification: Optionally skip SSL certificate verification.

## Viewing Repositories
After synchronization, repositories are stored in the files/git_repositories directory. The plugin displays:
Identifier: Extracted from the repository URL.
Path: Local filesystem path with .git appended.
Contents: List of files within the repository.

![image](https://github.com/user-attachments/assets/8a53e21e-2883-44d4-ac81-b1e9f05fb541)

Note: This plugin only performs synchronization. For tracking and other SCM functionalities, use Redmine's built-in Git SCM feature using output data.

![image](https://github.com/user-attachments/assets/5e23c90c-cd55-4a28-83a0-9061222225a2)


## Licence
Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.
