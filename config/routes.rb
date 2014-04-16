Viralata::Application.routes.draw do
  root :to => 'search#index'
  
  get 'destination', to: 'search#destination'
  get 'search/search_response', to: 'search#search_response'
  
  # Temporary
  get 'CSV', to: 'search#testcsv'
  get 'busroutes', to: 'search#busroutes'
  get 'buscompany', to: 'search#buscompany'

  resources :companies do
    resources :routes, shallow: true
  end
end
