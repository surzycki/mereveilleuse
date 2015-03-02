Rails.application.routes.draw do
  match 'canvas', to: 'test#index', via: [:get, :post]
  root 'test#index'
end
