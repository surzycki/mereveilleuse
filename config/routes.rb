Rails.application.routes.draw do
  match 'session',    to: 'sessions#index',         via: [:get, :post] 
  
  get   'referral',   to: 'referrals#index'
  get   'assessment', to: 'assessments#index'
  get   'search',     to: 'searches#index'

  # custom error pages
  match '/404', to: 'errors#not_found',             via: :all, as: :not_found
  match '/422', to: 'errors#unprocessable_entity',  via: :all, as: :unprocessable_entity
  match '/500', to: 'errors#internal_server_error', via: :all, as: :internal_server_error

  root 'sessions#index'
end
