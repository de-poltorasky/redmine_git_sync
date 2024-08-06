Redmine::Plugin.register :redmine_git_sync do
  name 'Redmine Git Sync plugin'
  author 'de Poltorasky'
  description 'This plugin allows synchronization of Git repositories'
  version '0.0.1'
  url 'https://github.com/de-poltorasky/redmine_git_syn'
  author_url 'https://github.com/de-poltorasky'
  
  project_module :git_sync do
    permission :view_git_sync, :git_sync => :index
    permission :sync_git_repositories, :git_sync => :sync
  end
  
  menu :project_menu, :git_sync, { :controller => 'git_sync', :action => 'index' }, :caption => 'Git Sync', :after => :activity, :param => :project_id
end
