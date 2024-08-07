resources :projects do
  resources :git_sync, only: [:index] do
    collection do
      post 'sync'
    end
    member do
      get 'show'
      get 'view_file'
    end
  end
end
