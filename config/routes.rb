# frozen_string_literal: true

Rails.application.routes.draw do
  root 'pages#home'

  get 'privacy', to: 'pages#privacy'
  get 'terms', to: 'pages#terms'

  devise_for :users

  get 'up' => 'rails/health#show', as: :rails_health_check
end
