Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  match 'session', to: 'sessions#index', via: [:get, :post] 
  
  resources :recommendations
  resource  :search, only: [ :new, :create, :show ]
  
  get 'practitioners/autocomplete',   to: 'practitioners#autocomplete', as: 'practitioners_autocomplete', constraints: { format: 'json' }

  get 'conditions-generales',         to: 'static_pages#conditions',    as: 'conditions'
  get 'politique-de-confidentialite', to: 'static_pages#privacy',       as: 'privacy'

  # custom error pages
  match '/404', to: 'errors#not_found',             via: :all, as: :not_found
  match '/422', to: 'errors#unprocessable_entity',  via: :all, as: :unprocessable_entity
  match '/500', to: 'errors#internal_server_error', via: :all, as: :internal_server_error

  root 'sessions#index'
end


