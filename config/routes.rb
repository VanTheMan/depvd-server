DepvdServer::Application.routes.draw do
  root to: 'albums#index'

  resources :albums, only: %w[index show] do 
    get 'filter_by_tag'
  end
  
end
