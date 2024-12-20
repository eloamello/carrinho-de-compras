require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  resources :carts, except: %i[show destroy] do
    post :add_items, on: :collection
  end

  get '/cart', to: 'carts#show', as: :show_cart
  resources :carts, only: :destroy, param: :product_id

  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end