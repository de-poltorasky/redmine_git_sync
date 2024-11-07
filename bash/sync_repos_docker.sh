#!/bin/bash

# Define the path to the git repositories directory
REPOS_DDIR="/XXXXX/"container_git_repositories"/
REPOS_LDIR="/XXXXX/"Host_git_repositories"/
# Define the name of the Redmine Docker container
CONTAINER_NAME="redmine_container_name"

# Check if the container is running
if ! docker ps | grep -q "$CONTAINER_NAME"; then
  echo "Container $CONTAINER_NAME is not running. Exiting."
  exit 1
fi

# Iterate over each repository in the directory
for repo in "$REPOS_LDIR"/*; do
  if [ -d "$repo/.git" ]; then
    repo_name=$(basename "$repo")
    echo "Updating repository: $repo_name"
    docker exec "$CONTAINER_NAME" bash -c "git config --global --add safe.directory $REPOS_DDIR$repo_name"
    docker exec "$CONTAINER_NAME" bash -c "cd $REPOS_DDIR$repo_name && git fetch --all"

 # Store the current branch to switch back to it later
    current_branch=$(docker exec "$CONTAINER_NAME" bash -c "cd $REPOS_DDIR$repo_name && git rev-parse --abbrev-ref HEAD")

    # Get the list of remote branches and update each
    remotebranch_list=$(docker exec "$CONTAINER_NAME" bash -c "cd $REPOS_DDIR$repo_name && git branch -r | grep -v '\->'")

    for branch in $remotebranch_list; do
      branchname=$(echo $branch | sed 's|origin/||')
      # Checkout the branch and pull the latest changes
      echo "Switching to branch: $branchname"
      docker exec "$CONTAINER_NAME" bash -c "cd $REPOS_DDIR$repo_name && git switch $branchname && git pull"
    done

    # Switch back to the original branch
    echo "Returning to the original branch: $current_branch"
    docker exec "$CONTAINER_NAME" bash -c "cd $REPOS_DDIR$repo_name && git switch $current_branch"

  fi
done
