Redmine::Plugin.register :redmine_git_sync do
  name 'Redmine Git Sync plugin'
  author 'Your Name'
  description 'This plugin allows synchronization of Git repositories'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  
  project_module :git_sync do
    permission :view_git_sync, :git_sync => :index
    permission :sync_git_repositories, :git_sync => :sync
  end
  
  menu :project_menu, :git_sync, { :controller => 'git_sync', :action => 'index' }, :caption => 'Git Sync', :after => :activity, :param => :project_id
end
