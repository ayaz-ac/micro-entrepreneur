# frozen_string_literal: true

require 'test_helper'

class ConfiguredOffDayFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_with_average_daily_rate_filled)
    sign_in @user
  end

  test 'it should update all futur ActivityReports if updating present or future ActivityReport' do
    create_activity_report_for_the_current_month(@user)

    create_activity_report_for_another_month(@activity_report.start_date + 1.month)
    create_activity_report_for_another_month(@activity_report.start_date - 1.month)

    assert_changes -> { @user.configured_off_days.size } do
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
