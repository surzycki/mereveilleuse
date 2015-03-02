Rails.application.routes.draw do
  match 'canvas',   to: 'canvas#index', via: [:get, :post]
  match 'referral', to: 'referral#index', via: [:get, :post]
  
  root 'referral#index'
end
