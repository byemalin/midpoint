Rails.application.routes.draw do
  devise_for :users
  # Defines the root path route ("/")
  root to: "pages#home"

  resources :meetups, only: [:show, :index, :destroy]

  resources :destinations, only: [:show] do
    resources :flights
  end

end
