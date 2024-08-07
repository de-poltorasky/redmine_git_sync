resources :projects do
  resources :git_sync, only: [:index] do
    collection do
      post 'sync'
    end
    member do
      get 'show_repo', to: 'git_sync#show', as: 'show_repo'
      get 'view_file', to: 'git_sync#view_file', as: 'view_file'
    end
  end
end


