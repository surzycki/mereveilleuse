Rails.application.routes.draw do
  require 'sidekiq/web'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  mount Sidekiq::Web, at: '/admin/sidekiq'
  
  # unbounce landing page
  get 'sinscrire',                      to: 'landings#unbounce'

  # registrations
  get 'registration/invite',            to: 'registrations#invite',       as: 'registration_invite' 
  get 'registration/identity',          to: 'registrations#identity',     as: 'registration_identity'
  get 'registration',                   to: 'registrations#identity'

  # unsubscribe
  get 'unsubscribe/search/:token/:id',  to: 'unsubscribes#search',        as: 'unsubscribe_search'
  get 'unsubscribe/account/:token',     to: 'unsubscribes#account',       as: 'unsubscribe_account'

  # json api
  get 'practitioners/autocomplete',   to: 'practitioners#autocomplete', as: 'practitioners_autocomplete', constraints: { format: 'json' }
  get 'professions/autocomplete',     to: 'professions#autocomplete',   as: 'professions_autocomplete',   constraints: { format: 'json' }
  
  get 'conditions-generales',         to: 'static_pages#conditions',    as: 'conditions'
  get 'mentions-legales',             to: 'static_pages#legal',         as: 'legal'
  get 'politique-de-confidentialite', to: 'static_pages#privacy',       as: 'privacy'

  get  'praticiens/merci',            to: 'squeezes#show',              as: 'squeeze_thanks'
  get  'praticiens/(:id)',            to: 'squeezes#index'
  post 'praticiens',                  to: 'squeezes#create',            as: 'squeeze_form'
 
  get  '/auth/:provider/callback',    to: 'identities#create'
  get  '/auth/failure',               to: 'identities#failure'

  #resource  :session,         only: [ :create, :show ]
  resource  :help,            only: [ :new, :create, :show ]
  resource  :search,          only: [ :new, :create, :show ]
  resource  :registration,    only: [ :new, :create ]
  resources :recommendations, only: [ :new, :create, :show ]
  
  

  # custom error pages
  match '/404', to: 'errors#not_found',             via: :all, as: :not_found
  match '/422', to: 'errors#unprocessable_entity',  via: :all, as: :unprocessable_entity
  match '/500', to: 'errors#internal_server_error', via: :all, as: :internal_server_error

  # ping for capistrano deploy
  get 'ping', to: proc { [200, {}, []] }

  root 'landings#index'
end


