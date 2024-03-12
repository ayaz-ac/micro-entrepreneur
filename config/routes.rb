# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  get 'privacy', to: 'pages#privacy'
  get 'terms', to: 'pages#terms'

  authenticated :user do
    root to: 'activity_reports#show', as: :authenticated_user
    resources :activity_reports, only: :show do
      resource :days, only: :update, module: :activity_reports
    end
    resource :configured_off_days, only: :update
    resources :users, only: %i[edit update]
  end

  root to: 'pages#home'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
