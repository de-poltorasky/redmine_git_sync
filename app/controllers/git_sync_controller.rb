def sync
  source_repo = params[:source_repo]
  api_key = params[:api_key]
  skip_ssl_verification = params[:skip_ssl_verification] == '1'

  # Validation et sanitisation de l'URL du dépôt source
  unless valid_git_url?(source_repo)
    flash[:error] = 'Invalid source repository URL'
    return redirect_to project_git_sync_index_path(@project)
  end

  # Extract project name from the source repository URL
  project_name = source_repo.split('/').last.sub('.git', '')
  project_dir = File.join(Rails.root, 'files', 'git_repositories', "#{project_name}_#{@project.id}")

  # Formatted clone URL
  clone_url = "https://pat:#{api_key}@#{source_repo.sub(/^https:\/\//, '')}"

  if Dir.exists?(project_dir)
    # Vérifier l'URL distante actuelle de manière sécurisée avec Open3
    current_remote_url = get_remote_url(project_dir)

    # Si l'URL distante ne contient pas le bon token, la mettre à jour
    if current_remote_url != clone_url
      git_set_url_cmd = ['git', 'remote', 'set-url', 'origin', clone_url]
      success = run_command_in_directory(git_set_url_cmd, project_dir)
    end

    # Mise à jour du dépôt avec git pull
    git_pull_cmd = ['git', 'pull']
    success = run_command_in_directory(git_pull_cmd, project_dir)
  else
    # Clone nouveau dépôt
    FileUtils.mkdir_p(project_dir)
    git_clone_cmd = ['git', 'clone']
    git_clone_cmd << '--config' << 'http.sslVerify=false' if skip_ssl_verification
    git_clone_cmd << clone_url << project_dir
    success = run_command_in_directory(git_clone_cmd, Rails.root)
  end

  if success
    flash[:notice] = 'Synchronization successful'
  else
    flash[:error] = 'Synchronization failed'
  end
  redirect_to project_git_sync_index_path(@project)
end

# Méthode pour récupérer l'URL distante de manière sécurisée
def get_remote_url(directory)
  stdout, stderr, status = Open3.capture3('git', 'config', '--get', 'remote.origin.url', chdir: directory)
  if status.success?
    return stdout.strip
  else
    Rails.logger.error("Failed to get remote URL: #{stderr}")
    return nil
  end
end
