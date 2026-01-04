# frozen_string_literal: true

class ConfiguredOffDaysController < AuthenticatedController
  def edit
    @user = current_user
    @configured_off_days = current_user.configured_off_days
  end

  def update
    # It's easier to just delete all the previous days and create new ones
    current_user.configured_off_days.destroy_all
    params[:off_days].each do |day_of_week|
      current_user.configured_off_days.create!(day_of_week: day_of_week)
    end

    @configured_off_days = current_user.configured_off_days.reload
    flash.now[:notice] = t('.success')
  end
end
