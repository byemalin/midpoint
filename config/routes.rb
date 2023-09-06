Rails.application.routes.draw do
  devise_for :users
  # Defines the root path route ("/")
  root to: "pages#home"
  resources :meetups, only: [:show, :create]
  resources :destinations, only: [:show]

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

 # get "destinations/:id/summary", to: "destinations#summary", as: "summary"
end
