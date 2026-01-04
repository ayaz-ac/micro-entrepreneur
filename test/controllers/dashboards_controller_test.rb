# frozen_string_literal: true

require 'test_helper'

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  setup do
    @user = users(:default)
    sign_in @user

    # Trigger activity report details initialization
    @user.update!(average_daily_rate: @user.average_daily_rate)
  end
  test 'it should render the show view' do
    get dashboards_url

    assert_response :success

    assert_select 'h3', "Bonjour, #{@user.first_name.capitalize} 👋"
  end

  test 'it should return the current yearly revenue' do
    current_yearly_revenue = @user.revenues.find_by(year: Time.zone.today.year).amount

    get dashboards_url

    assert_response :success

    assert_select 'span', format_number_to_currency(current_yearly_revenue)
  end

  test 'it should return the current month income' do
    current_month_income = @user.activity_reports.find_by(
      start_date: Time.zone.today.beginning_of_month,
      end_date: Time.zone.today.end_of_month
    ).estimated_income

    get dashboards_url

    assert_response :success

    assert_select 'span', format_number_to_currency(current_month_income)
  end

  test 'it should render the profitable statistic' do
    # Update user to trigger activity report initialization
    @user.update!(average_daily_rate: 800)

    # Mark all future days as 'off' to have zero future revenue
    @user.activity_reports.from_this_month.each do |report|
      report.details['monthly_revenue'] = 0
      report.details['estimated_income'] = 0
      report.days.each { |day| day['status'] = 'off' }
      report.save!
    end

    # Set current yearly revenue to test profitable status
    # Profitable status requires: estimated_yearly_revenue <= 77,700 AND estimated_yearly_revenue + 800 >= 77,700
    # With zero future revenue, we need current revenue around 77,000
    @user.revenues.find_by(year: Time.zone.today.year).update!(amount: 77_000)

    get dashboards_url

    assert_response :success

    assert_select 'span', text: 'Congés restants'
    assert_select 'span', text: 'Pour ne pas dépasser le plafond du CA'
    assert_select 'span', text: 'Gains manqués', count: 0
  end

  test 'it should not render the profitable statistic' do
    @user.update(average_daily_rate: 100)

    @user.revenues.last.update!(amount: 0)

    get dashboards_url

    assert_response :success

    assert_select 'span', text: 'Gains manqués'
    assert_select 'span', text: 'Congés restants', count: 0
  end

  test "it should return a 404 error if there's no current yearly revenue" do
    @user.revenues.find_by(year: Time.zone.today.year).destroy!

    get dashboards_url

    assert_response :not_found
  end

  test "it should return a 404 error if there's no current month income" do
    @user.activity_reports.find_by(
      start_date: Time.zone.today.beginning_of_month,
      end_date: Time.zone.today.end_of_month
    ).destroy!

    get dashboards_url

    assert_response :not_found
  end
end
