Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  resource :users, only: :create, path: '/signup'
  
  get '/signup', to: 'users#new'

  resource :sessions, only: %i[create destroy]
  
  get '/login', to: 'sessions#new'

  resources :keywords, only: %i[index show create]
end
