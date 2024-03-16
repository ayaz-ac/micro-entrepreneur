# frozen_string_literal: true

require 'test_helper'

class ActivityReportFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:default)
    sign_in @user
  end

  test 'it should create ActivityReports for the current and next months with the financial values' do
    create_activity_report_for_the_current_month(@user)

    assert_equal 0, @activity_report.average_daily_rate
    assert_equal 0, @activity_report.estimated_income
    assert_select 'a', 'Veuillez mettre à jour votre TJM pour estimer vos revenus'

    update_user_average_daily_rate

    assert_changes -> { @activity_report.average_daily_rate }, from: 0, to: @user.average_daily_rate do
      @activity_report.reload
    end

    assert_not_equal 0, @activity_report.estimated_income

    get root_path
    assert_select 'a', text: 'Veuillez mettre à jour votre TJM pour estimer vos revenus', count: 0

    create_activity_report_for_another_month(@activity_report.start_date + 1.month)

    @next_month_activity_report = @user.activity_reports.last
    assert_equal @user.average_daily_rate, @next_month_activity_report.average_daily_rate
    assert_not_equal 0, @next_month_activity_report.estimated_income

    update_user_average_daily_rate(0)

    assert_activity_reports_from_this_month_and_the_next_ones
  end

  test 'it should create ActivityReports for the current and previous months with the correct financial values' do
    update_user_average_daily_rate

    create_activity_report_for_the_current_month(@user)

    create_activity_report_for_another_month(@activity_report.start_date - 1.month)

    @previous_month_activity_report = @user.activity_reports.last
    assert_equal @user.average_daily_rate, @previous_month_activity_report.average_daily_rate
    assert_not_equal 0, @previous_month_activity_report.estimated_income

    update_user_average_daily_rate(0)

    assert_activity_reports_from_this_month_and_the_next_ones

    @user.activity_reports.before_this_month.each do |activity_report|
      assert_not_equal @user.average_daily_rate, activity_report.average_daily_rate
      assert_not_equal 0, activity_report.estimated_income
    end
  end

  test 'it should update the average daily rate for the previous months ActivityReports' do
    create_activity_report_for_the_current_month(@user)

    create_activity_report_for_another_month(@activity_report.start_date - 1.month)

    get root_path(date: @activity_report.start_date - 1.month)

    @previous_month_activity_report = @user.activity_reports.last

    assert_select 'form#configured_off_days', count: 0
    assert_select 'form#update_average_daily_rate'

    new_average_daily_rate = 300

    assert_changes -> { @previous_month_activity_report.average_daily_rate }, from: 0, to: new_average_daily_rate do
      put activity_report_path(@previous_month_activity_report),
          params: { activity_report: { average_daily_rate: new_average_daily_rate } }
      @previous_month_activity_report.reload
    end

    assert_not_equal @previous_month_activity_report, @activity_report
  end

  private

  def update_user_average_daily_rate(new_average_daily_rate = 300)
    assert_changes -> { @user.average_daily_rate }, from: @user.average_daily_rate, to: new_average_daily_rate do
      put user_path(@user), params: { user: { average_daily_rate: new_average_daily_rate } }
      @user.reload
    end
  end

  def assert_activity_reports_from_this_month_and_the_next_ones
    @user.activity_reports.from_this_month.each do |activity_report|
      assert_equal @user.average_daily_rate, activity_report.average_daily_rate
      assert_equal 0, activity_report.estimated_income
    end
  end
end
