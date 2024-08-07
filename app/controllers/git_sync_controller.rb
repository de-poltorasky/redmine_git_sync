class GitSyncController < ApplicationController
  unloadable
  before_action :find_project, :authorize

  def index
    @repositories = Dir.glob(File.join(Rails.root, 'plugins', 'redmine_git_sync', 'repositories', '*')).select { |f| File.directory? f }
  end

  def show
    @repository = params[:repo]
    @files = Dir.glob(File.join(@repository, '**', '*')).select { |f| File.file? f }
  end

  def view_file
    @file_path = params[:file_path]
    @file_content = File.read(@file_path)
  end

  def sync
    source_repo = params[:source_repo]
    api_key = params[:api_key]
    project_name = params[:project_name]
    skip_ssl_verification = params[:skip_ssl_verification] == '1'
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    project_dir = File.join(Rails.root, 'plugins', 'redmine_git_sync', 'repositories', project_name)

    # Delete project directory if it exists
    if Dir.exists?(project_dir)
      FileUtils.rm_rf(project_dir)
    end

    # Create new project directory
    FileUtils.mkdir_p(project_dir)

    # Formatted clone URL
    clone_url = "https://#{api_key}@#{source_repo.sub(/^https:\/\//, '')}"

    # Git clone command
    git_clone_cmd = "git clone #{'--config http.sslVerify=false ' if skip_ssl_verification}#{clone_url} #{project_dir}"
    git_push_cmd = "cd #{project_dir} && git push --mirror ."

    if system(git_clone_cmd) && system(git_push_cmd)
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
