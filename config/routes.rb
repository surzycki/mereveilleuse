Rails.application.routes.draw do
  match 'session',    to: 'sessions#index', via: [:get, :post] 
  get   'referral',   to: 'referrals#index'
  get   'assessment', to: 'assessments#index'
  get   'search',     to: 'searches#index'

  root 'sessions#index'
end
