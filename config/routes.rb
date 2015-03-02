Rails.application.routes.draw do
  match 'session',    to: 'sessions#index', via: [:get, :post] 
  get   'referral',   to: 'referrals#index'
  get   'assessment', to: 'assessments#index'

  root 'sessions#index'
end
