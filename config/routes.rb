resources :projects do
  resources :git_sync, only: [:index] do
    collection do
      post 'sync'
    end
  end
end
