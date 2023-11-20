Rails.application.routes.draw do
  devise_for :users
  # Defines the root path route ("/")
  root to: "pages#home"
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
  get "conditions", to: "pages#conditions"
  get "privacy", to: "pages#privacy"
  resources :meetups, only: [:show, :create]
  resources :destinations, only: [:show]
  resources :tequila_airports, only: [:index]

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

 # get "destinations/:id/summary", to: "destinations#summary", as: "summary"
end
