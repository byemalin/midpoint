Rails.application.routes.draw do
  devise_for :users
  # Defines the root path route ("/")
  root to: "pages#home"
  resources :meetups, only: [:show, :create]
  resources :destinations, only: [:show]

  get "destinations/:id/summary", to: "destinations#summary", as: "summary"
end
