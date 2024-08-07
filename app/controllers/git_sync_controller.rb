class GitSyncController < ApplicationController
  unloadable
  before_action :find_project, :authorize

  def index
    @repositories = Dir.glob(File.join(Rails.root, 'files', 'git_repositories', '*')).select { |f| File.directory? f }
  end

  def sync
    source_repo = params[:source_repo]
    api_key = params[:api_key]
    skip_ssl_verification = params[:skip_ssl_verification] == '1'

    # Extract project name from the source repository URL
    project_name = source_repo.split('/').last.sub('.git', '')
    project_dir = File.join(Rails.root, 'files', 'git_repositories', "#{project_name}_#{@project.id}")

    # Formatted clone URL
    clone_url = "https://#{api_key}@#{source_repo.sub(/^https:\/\//, '')}"

    if Dir.exists?(project_dir)
      # Update existing repository
      git_pull_cmd = "cd #{project_dir} && git pull #{'--config http.sslVerify=false ' if skip_ssl_verification}#{clone_url}"
      success = system(git_pull_cmd)
    else
      # Clone new repository
      FileUtils.mkdir_p(project_dir)
      git_clone_cmd = "git clone #{'--config http.sslVerify=false ' if skip_ssl_verification}#{clone_url} #{project_dir}"
      success = system(git_clone_cmd)
    end

    if success
      flash[:notice] = 'Synchronization successful'
    else
      flash[:error] = 'Synchronization failed'
    end
    redirect_to project_git_sync_index_path(@project)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end
end
