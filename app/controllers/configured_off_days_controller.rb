# frozen_string_literal: true

class ConfiguredOffDaysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_configured_off_days
  before_action :find_activity_report

  def update
    existing_off_days_to_delete = @user_configured_off_days - configured_off_days
    selected_off_days_to_add = configured_off_days - @user_configured_off_days

    destroy_exisiting_off_days_unchecked(existing_off_days_to_delete)
    create_newly_selected_off_days(selected_off_days_to_add)

    @user_off_days = ConfiguredOffDay.where(user: current_user)
  end

  private

  def configured_off_day_params
    params.require(:user).permit(:activity_report_id, configured_off_days: [])
  end

  def set_user_configured_off_days
    @user_configured_off_days = current_user.configured_off_days.map(&:day_of_week)
  end

  def find_activity_report
    @activity_report = ActivityReport.find(configured_off_day_params[:activity_report_id])
  end

  def configured_off_days
    @configured_off_days ||= (configured_off_day_params[:configured_off_days] || [])
  end

  def destroy_exisiting_off_days_unchecked(days_of_week)
    return if days_of_week.empty?

    current_user.configured_off_days.where(day_of_week: days_of_week).destroy_all
  end

  def create_newly_selected_off_days(days_of_week)
    return if days_of_week.empty?

    days_of_week.each do |day_of_week|
      current_user.configured_off_days.create!(day_of_week:)
    end
  end
end
