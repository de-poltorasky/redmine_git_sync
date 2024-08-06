namespace :git_sync do
  desc "Synchronize Git repositories"
  task :sync => :environment do
    source_repo = ENV['SOURCE_REPO']
    target_repo = ENV['TARGET_REPO']
    api_key = ENV['API_KEY']
    project_name = ENV['PROJECT_NAME']
    project_dir = File.join(Rails.root, 'git_repositories', project_name)

    # Create project directory if it doesn't exist
    FileUtils.mkdir_p(project_dir) unless Dir.exists?(project_dir)

    # Clone and push using API key
    if system("git clone https://#{api_key}@#{source_repo} #{project_dir} && cd #{project_dir} && git push --mirror https://#{api_key}@#{target_repo}")
      puts 'Synchronization successful'
    else
      puts 'Synchronization failed'
    end
  end
end
