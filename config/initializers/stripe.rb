# frozen_string_literal: true

require 'stripe'

if Rails.application.credentials[Rails.env.to_sym]
  Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:stripe][:secret_key]
end
