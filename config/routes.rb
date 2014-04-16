Viralata::Application.routes.draw do
  root :to => 'search#index'
  get 'destination', to: 'search#destination'
  get 'path', to: 'search#path'
  
  # Temporary
  get 'busroutes', to: 'search#busroutes'
  get 'buscompany', to: 'search#buscompany'

  resources :companies do
    resources :routes, shallow: true
  end
end
