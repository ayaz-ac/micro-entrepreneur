# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  get 'privacy', to: 'pages#privacy'
  get 'terms', to: 'pages#terms'

  authenticated :user do
    root to: 'dashboards#show', as: :authenticated_user
    resource :dashboards, only: :show
    resource :activity_reports, only: :show
    resources :activity_report, only: %i[] do
      resource :days, only: :update, module: :activity_reports
    end
    resource :configured_off_days, only: :update
    resources :users, only: %i[edit update]
  end

  root to: 'pages#home'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
