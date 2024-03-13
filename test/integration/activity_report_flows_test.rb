# frozen_string_literal: true

require 'test_helper'

class ActivityReportFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:default)
    sign_in @user
  end

  test 'it should create ActivityReports for the current and next months with the correct values' do
    # Create ActivityReport for the current month
    assert_difference -> { ActivityReport.count } do
      get root_path
    end

    @activity_report = @user.activity_reports.first

    assert_equal 0, @activity_report.average_daily_rate
    assert_equal 0, @activity_report.estimated_income
    assert_select 'a', 'Veuillez mettre à jour votre TJM pour estimer vos revenus'

    # Update user's average_daily_rate
    new_average_daily_rate = 300
    assert_changes -> { @user.average_daily_rate }, from: 0, to: new_average_daily_rate do
      put user_path(@user), params: { user: { average_daily_rate: new_average_daily_rate } }
      @user.reload
    end

    assert_changes -> { @activity_report.average_daily_rate }, from: 0, to: @user.average_daily_rate do
      @activity_report.reload
    end

    assert_not_equal 0, @activity_report.estimated_income

    get root_path
    assert_select 'a', text: 'Veuillez mettre à jour votre TJM pour estimer vos revenus', count: 0

    # Create ActivityReport for the next month
    assert_difference -> { ActivityReport.count } do
      get root_path(date: @activity_report.start_date + 1.month)
    end

    @next_month_activity_report = @user.activity_reports.last
    assert_equal @user.average_daily_rate, @next_month_activity_report.average_daily_rate
    assert_not_equal 0, @next_month_activity_report.estimated_income

    # Update user's average_daily_rate to 0
    assert_changes -> { @user.average_daily_rate }, from: new_average_daily_rate, to: 0 do
      put user_path(@user), params: { user: { average_daily_rate: 0 } }
      @user.reload
    end

    @user.activity_reports.from_this_month.each do |activity_report|
      assert_equal @user.average_daily_rate, activity_report.average_daily_rate
      assert_equal 0, activity_report.estimated_income
    end
  end
end
