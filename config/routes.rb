Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  resource :users, only: :create, path: '/signup'
  
  get '/signup', to: 'users#new'

  resource :sessions, only: %i[create destroy]
  
  get '/login', to: 'sessions#new'

  resource :keywords, only: :create

  get '/keywords', to: 'keywords#index'
end
