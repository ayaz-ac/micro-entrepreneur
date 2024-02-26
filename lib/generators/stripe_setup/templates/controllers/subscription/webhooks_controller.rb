# frozen_string_literal: true

module Stripe
  class WebhooksController < ActionController::API
    def create
      process_event

      render json: {}, status: :ok
    rescue NoMethodError, JSON::ParserError, SignatureVerificationError
      render json: {}, status: :bad_request
    end

    private

    def event
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      signature = Rails.application.credentials[Rails.env.to_sym][:stripe][:webhook_key]
      Stripe::Webhook.construct_event(payload, sig_header, signature)
    end

    def process_event
      case event.type
      when 'invoice.paid'
        increment_user_premium(event.data.object.customer)
      when 'invoice.payment_failed'
        revoke_user_access(event.data.object.customer)
      end
    end

    def increment_user_premium(stripe_id)
      user = User.find_by(stripe_id:)

      return unless user

      user.increment_premium
      user.save!
    end

    def revoke_user_access(stripe_id)
      user = User.find_by(stripe_id:)

      return unless user

      user.update!(premium_until: nil)
    end
  end
end
