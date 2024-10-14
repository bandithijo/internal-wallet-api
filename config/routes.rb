Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  post "sign-in", to: "sessions#create", defaults: { format: :json }
  delete "sign-out", to: "sessions#destroy", defaults: { format: :json }

  resource :wallet, only: [ :show ], defaults: { format: :json } do
    collection do
      post :deposit, defaults: { format: :json }
      post :withdraw, defaults: { format: :json }
      post :transfer, defaults: { format: :json }
    end
  end

  resources :transactions, only: [ :index ], defaults: { format: :json }
end
