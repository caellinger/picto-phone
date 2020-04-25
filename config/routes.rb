Rails.application.routes.draw do
  root 'homes#index'
  devise_for :users

  get '/rounds', to: "homes#index"

  namespace :api do
    namespace :v1 do
      resources :rounds, only: [:index]
    end
  end
end
