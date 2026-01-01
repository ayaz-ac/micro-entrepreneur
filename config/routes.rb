# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  resource :dashboards, only: :show
  resource :activity_reports, only: :show
  resources :activity_report, only: %i[] do
    resource :days, only: :update, module: :activity_reports
  end

  resource :average_daily_rate, only: %i[edit update]
  resource :configured_off_days, only: %i[edit update] 

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  get 'up' => 'rails/health#show', as: :rails_health_check
end
