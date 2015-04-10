Rails.application.routes.draw do
  require 'sidekiq/web'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  mount Sidekiq::Web, at: '/admin/sidekiq'
  
  resource  :session,         only: [ :create, :show ]
  resource  :help,            only: [ :new, :create, :show ]
  resource  :search,          only: [ :new, :create, :show ]
  resources :recommendations, only: [ :new, :create, :show ]
  resources :registrations,   only: [ :new, :create, :show ]
  
  # facebook canvas app entry
  # post 'session/canvas',              to: 'sessions#canvas',            as: 'session_canvas'

  # unsubscribe
  get 'unsubscribe/search/:id',       to: 'unsubscribes#search',        as: 'unsubscribe_search'
  get 'unsubscribe/account/:id',      to: 'unsubscribes#account',       as: 'unsubscribe_account'

  # json api
  get 'practitioners/autocomplete',   to: 'practitioners#autocomplete', as: 'practitioners_autocomplete', constraints: { format: 'json' }
  get 'professions/autocomplete',     to: 'professions#autocomplete',   as: 'professions_autocomplete',   constraints: { format: 'json' }
  
  get 'conditions-generales',         to: 'static_pages#conditions',    as: 'conditions'
  get 'mentions-legales',             to: 'static_pages#legal',         as: 'legal'
  get 'politique-de-confidentialite', to: 'static_pages#privacy',       as: 'privacy'

  # custom error pages
  match '/404', to: 'errors#not_found',             via: :all, as: :not_found
  match '/422', to: 'errors#unprocessable_entity',  via: :all, as: :unprocessable_entity
  match '/500', to: 'errors#internal_server_error', via: :all, as: :internal_server_error

  # ping for capistrano deploy
  get 'ping', to: proc { [200, {}, []] }

  root 'registrations#new'
end


