# frozen_string_literal: true

module Stripe
  class SuccessfulCheckoutsController < ApplicationController
    def show
      current_user.update!(premium: true)

      flash[:notice] = t('.successful')
      redirect_to root_url
    end
  end
end
