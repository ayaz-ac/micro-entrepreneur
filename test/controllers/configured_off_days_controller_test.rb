# frozen_string_literal: true

require 'test_helper'

class ConfiguredOffDaysControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:default)
    sign_in @user

    @user.update!(average_daily_rate: 500)
  end

  test 'it should update the configured off days of the future months' do
    @activity_report = @user.activity_reports.find_by(start_date: Time.zone.today.beginning_of_month)

    existing_configured_days = @user.configured_off_days_of_week
    new_configured_days = %w[monday tuesday]

    assert_difference -> { @user.configured_off_days.count }, new_configured_days.size do
      patch configured_off_days_url(params: {
                                      off_days: new_configured_days + existing_configured_days
                                    }, format: :turbo_stream)
      assert_response :success

      @user.reload

      assert (new_configured_days + existing_configured_days).sort == @user.configured_off_days_of_week.sort
    end

    # Check if future months are updated
    @user.activity_reports.from_this_month.find_each do |activity_report|
      activity_report.days.each do |day|
        assert_equal 'off', day['status'], 'Day is supposed to be off' if off_day?(day['date'], new_configured_days)
      end
    end

    # Check if past months arent' update
    @user.activity_reports.before_this_month.find_each do |activity_report|
      activity_report.days.each do |day|
        assert_not_equal 'off', day['status'], "Day isn't supposed to be off" if off_day?(day['date'],
                                                                                          new_configured_days)
      end
    end
  end

  test 'it should add a new configured off day' do
    assert_difference -> { @user.configured_off_days.count } do
      new_configured_days = @user.configured_off_days_of_week << 'monday'

      patch configured_off_days_url(params: {
                                      off_days: new_configured_days
                                    }, format: :turbo_stream)

      assert_response :success

      @user.reload
    end
  end

  private

  def off_day?(date, configured_off_days)
    configured_off_days.include?(Date.parse(date).strftime('%A').downcase)
  end
end
