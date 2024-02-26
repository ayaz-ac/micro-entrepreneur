# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|fr/ do
    get '/:locale' => 'pages#home'
    root 'pages#home'

    get 'privacy', to: 'pages#privacy'
    get 'terms', to: 'pages#terms'

    devise_for :users
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
