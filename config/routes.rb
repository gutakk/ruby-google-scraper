Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: :index, path: '/'
  resource :users, only: :create, path: '/signup'
  get '/signup', to: 'users#new'

  resource :sessions, only: :create, path: '/login'
  get '/login', to: 'sessions#new'
end
