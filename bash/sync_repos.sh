#!/bin/bash

# Define the path to the git repositories directory
REPOS_DIR="/xxxx/git_repositories"

# Iterate over each repository in the directory
for repo in "$REPOS_DIR"/*; do
  if [ -d "$repo/.git" ]; then
    repo_name=$(basename "$repo")
    echo "Updating repository: $repo_name"
    
    # Navigate to the repository and fetch all branches
    cd "$repo" || continue
    git fetch --all

    # Store the current branch to switch back to it later
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Get the list of remote branches and update each
    remotebranch_list=$(git branch -r | grep -v '\->')

    for branch in $remotebranch_list; do
      branchname=$(echo $branch | sed 's|origin/||')
      
      # Checkout the branch and pull the latest changes
      echo "Switching to branch: $branchname"
      git switch "$branchname" && git pull
    done

    # Switch back to the original branch
    echo "Returning to the original branch: $current_branch"
    git switch "$current_branch"
  fi
done
