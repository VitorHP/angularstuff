Rails.application.routes.draw do

  resources :application, only: [:index]

  root to: 'application#index'
end
