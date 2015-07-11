Rails.application.routes.draw do
  resources :plans, only: :index
  resources :subscribe, only: [:destroy, :update]
  resources :merchants
  resources :reports
  resources :transfers, only: :index
  devise_for :users
  resources :users, only: [:update]
  root to: 'products#index'
  resources :charges, only: [:new, :create]
  resources :refunds, only: [:create]
  resources :products
  resources :purchases, only: [:index]
  resources :pending_products

  put 'approve_product' => 'pending_products#approve_product'
end
