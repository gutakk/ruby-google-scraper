Rails.application.routes.draw do
  use_doorkeeper do
    # Only use applications_controller to manage OAuth2 applications
    skip_controllers :tokens, :token_info, :authorized_applications
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  resource :users, only: :create, path: '/signup'
  
  get '/signup', to: 'users#new'

  resource :sessions, only: %i[create destroy]
  
  get '/login', to: 'sessions#new'

  resources :keywords, only: %i[index show create]

  namespace :api do
    namespace :v1 do
      use_doorkeeper do
        # Only need the tokens_controller for API V1
        controllers tokens: 'tokens'

        skip_controllers :applications, :authorizations, :token_info, :authorized_applications
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resource :users, only: :create
    end
  end
end
