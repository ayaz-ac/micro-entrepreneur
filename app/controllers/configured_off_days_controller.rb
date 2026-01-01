# frozen_string_literal: true

class ConfiguredOffDaysController < AuthenticatedController
  before_action :set_user_configured_off_days

  def edit
    @user = current_user
    @configured_off_days = current_user.configured_off_days
  end

  def update
    # Check if this is from the settings page (off_days param) or activity reports (user param)
    if params[:off_days].present?
      update_from_settings
    else
      update_from_activity_reports
    end
  end

  private

  def update_from_settings
    @user = current_user
    @configured_off_days = current_user.configured_off_days

    # Destroy all existing off days
    @configured_off_days.destroy_all

    # Create new off days based on selected days
    params[:off_days].each do |day_of_week|
      current_user.configured_off_days.create!(day_of_week: day_of_week)
    end

    @configured_off_days = current_user.configured_off_days.reload
    render :edit, status: :ok
  end

  def update_from_activity_reports
    existing_off_days_to_delete = @user_configured_off_days - configured_off_days
    selected_off_days_to_add = configured_off_days - @user_configured_off_days

    destroy_exisiting_off_days_unchecked(existing_off_days_to_delete)
    create_newly_selected_off_days(selected_off_days_to_add)

    @updated_activity_reports = current_user.activity_reports.from_this_month.each(&:update_days_status_in_details)

    find_updated_activity_report
  end

  def configured_off_day_params
    params.require(:user).permit(:activity_report_id, configured_off_days: [])
  end

  def set_user_configured_off_days
    @user_configured_off_days = current_user.configured_off_days_of_week
  end

  def find_updated_activity_report
    @activity_report = @updated_activity_reports.find do |activity_report|
      activity_report.id == configured_off_day_params[:activity_report_id].to_i
    end
  end

  def configured_off_days
    @configured_off_days ||= configured_off_day_params[:configured_off_days] || []
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
