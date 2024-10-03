require 'open3'

class GitSyncController < ApplicationController
  unloadable
  before_action :find_project, :authorize
    project_base_dir = File.join(Rails.root, 'files', 'git_repositories', "*_#{@project.id}")
    @repositories = Dir.glob(project_base_dir).select { |f| File.directory?(f) }

  def index
  end

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
      # Vérifier l'URL distante actuelle
      current_remote_url = `cd #{project_dir} && git config --get remote.origin.url`.strip

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

  private

  # Méthode pour exécuter des commandes dans un répertoire donné
  def run_command_in_directory(command, directory)
    stdout, stderr, status = Open3.capture3(*command, chdir: directory)
    Rails.logger.info("Command stdout: #{stdout}")
    Rails.logger.error("Command stderr: #{stderr}") unless status.success?
    return status.success?
  end

  # Validation basique de l'URL du dépôt git
  def valid_git_url?(url)
    # Accepte uniquement les URL commençant par http/https et se terminant par .git
    url =~ /\Ahttps:\/\/[\w.-]+\/[\w.-]+\.git\z/
  end

  def find_project
    @project = Project.find(params[:project_id])
  end
end
