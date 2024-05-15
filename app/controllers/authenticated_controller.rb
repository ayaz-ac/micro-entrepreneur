# frozen_string_literal: true

class AuthenticatedController < ApplicationController
  before_action :redirect_unless_premium, if: :user_signed_in?

  private

  def redirect_unless_premium
    return if current_user.premium?

    session = create_stripe_checkout_session

    redirect_to session.url, allow_other_host: true
  end

  def create_stripe_checkout_session
    Stripe::Checkout::Session.create(
      {
        line_items: [{ price: stripe_price_id, quantity: 1 }],
        mode: 'payment',
        customer_email: current_user.email,
        success_url: stripe_successful_checkout_url,
        cancel_url: root_url
      }
    )
  end

  def stripe_price_id
    Rails.application.credentials[Rails.env.to_sym][:stripe][:price_id]
  end
end
