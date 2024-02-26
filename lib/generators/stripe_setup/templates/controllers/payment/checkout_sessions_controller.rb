# frozen_string_literal: true

module Stripe
  class CheckoutSessionsController < ApplicationController
    def create
      redirect_to stripe_session.url, allow_other_host: true
    end

    private

    def checkout_session_params
      params.require(:checkout_session).permit(:price_id)
    end

    def stripe_session
      Stripe::Checkout::Session.create({
                                         line_items: [{
                                           price: checkout_session_params[:price_id],
                                           quantity: 1
                                         }],
                                         mode: 'payment',
                                         success_url: "#{new_user_registration_url}?session_id={CHECKOUT_SESSION_ID}",
                                         cancel_url: root_url
                                       })
    end
  end
end
