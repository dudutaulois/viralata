Viralata::Application.routes.draw do
  root :to => 'search#index'
  
  get 'Destination', to: 'search#destination'
  get 'search/search_response', to: 'search#search_response'
  get 'CSV', to: 'search#testcsv'
 
  
end
