class GitSyncController < ApplicationController
  unloadable
  before_action :find_project, :authorize

  def index
  end

  def sync
    source_repo = params[:source_repo]
    target_repo = params[:target_repo]
    api_key = params[:api_key]
    project_name = params[:project_name]
    project_dir = File.join(Rails.root, 'git_repositories', project_name)

    # Create project directory if it doesn't exist
    FileUtils.mkdir_p(project_dir) unless Dir.exists?(project_dir)

    # Clone and push using API key
    if system("git clone https://#{api_key}@#{source_repo} #{project_dir} && cd #{project_dir} && git push --mirror https://#{api_key}@#{target_repo}")
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
