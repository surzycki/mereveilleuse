Rails.application.routes.draw do
  match 'referral', to: 'referral#index', via: [:get, :post]
  root 'referral#index'
end
