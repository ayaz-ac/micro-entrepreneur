# frozen_string_literal: true

class HomeController < ApplicationController
  layout 'landing'

  before_action :redirect_if_logged_in, if: :user_signed_in?

  def index; end

  private

  def redirect_if_logged_in
    redirect_to dashboards_path
  end
end
