Rails.application.routes.draw do
  root 'homes#index'
  devise_for :users

  get '/', to: "homes#index"
  get '/rounds', to: "homes#index"
  get '/rounds/:id', to: "homes#authenticate"

  namespace :api do
    namespace :v1 do
      resources :rounds, only: [:index, :create, :show, :update]
      resources :participants, only: [:create]
      resources :drawings, only: [:show, :create]
    end
  end
end
