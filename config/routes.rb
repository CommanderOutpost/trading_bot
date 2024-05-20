Rails.application.routes.draw do
  resources :settings

  get "home/index"
  root "home#index"

  get "auth/logout"

  get "auth/change_password", to: "auth#change_password"
  post "auth/change_password", to: "auth#change_password"

  get "auth/register"
  post "auth/register"

  get "auth/login"
  post "auth/login"

  post "trade/start"
  post "trade/stop"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
