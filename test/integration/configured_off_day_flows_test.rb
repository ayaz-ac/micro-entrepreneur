# frozen_string_literal: true

require 'test_helper'

class ConfiguredOffDayFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:default)
    
    # Trigger after_validation :initialize_details in ActivityReportDetails
    @user.update!(average_daily_rate: 500) 
    
    sign_in @user
  end

  test 'it should update the configured off days of current and future ActivityReports' do
    assert_changes -> { @user.configured_off_days.size } do
      @activity_report = @user.activity_reports.find_by(
        start_date: Time.zone.today.beginning_of_month,
        end_date: Time.zone.today.end_of_month
      )
      
      put configured_off_days_path,
          params: { user: { activity_report_id: @activity_report.id, configured_off_days: %w[monday saturday sunday] } }
      @user.reload
    end

    @user.activity_reports.from_this_month.each do |activity_report|
      activity_report.days.each do |day|
        assert_equal 'off', day['status'], 'Day is supposed to be off' if off_day?(day['date'])
      end
    end

    @user.activity_reports.before_this_month.each do |activity_report|
      activity_report.days.each do |day|
        assert_not_equal 'off', day['status'] if lowercase_weekday(day['date']) == 'monday'
      end
    end
  end

  private

  def off_day?(day)
    off_days.include?(lowercase_weekday(day))
  end

  def off_days
    @off_days ||= @user.configured_off_days_of_week
  end

  def lowercase_weekday(date)
    date = Date.parse(date) if date.is_a? String
    date.strftime('%A').downcase
  end
end
