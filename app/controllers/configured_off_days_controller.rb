# frozen_string_literal: true

class ConfiguredOffDaysController < ApplicationController
  before_action :authenticate_user!

  def update; end

  private

  def configured_off_day_params
    params.require(:user).permit(:x)
  end
end
