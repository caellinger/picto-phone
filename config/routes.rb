Rails.application.routes.draw do
  root 'homes#index'
  devise_for :users

  get '/', to: "homes#authenticate"
  get '/rounds', to: "homes#authenticate"
  get '/rounds/:id', to: "homes#authenticate"

  namespace :api do
    namespace :v1 do
      resources :rounds, only: [:index, :create, :show, :update]
      resources :participants, only: [:create]
      resources :drawings, only: [:create]
    end
  end
end
