namespace :git_sync do
  desc "Synchronize Git repositories"
  task :sync => :environment do
    source_repo = ENV['SOURCE_REPO']
    api_key = ENV['API_KEY']
    project_name = ENV['PROJECT_NAME']
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    project_dir = File.join(Rails.root, 'plugins', 'redmine_git_sync', 'repositories', "#{project_name}_#{timestamp}")

    # Create project directory if it doesn't exist
    FileUtils.mkdir_p(project_dir) unless Dir.exists?(project_dir)

    # Clone and push using API key
    clone_url = "https://#{api_key}@#{source_repo}"
    if system("git clone #{clone_url} #{project_dir} && cd #{project_dir} && git push --mirror .")
      puts 'Synchronization successful'
    else
      puts 'Synchronization failed'
    end
  end
end
