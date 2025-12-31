# frozen_string_literal: true

require 'test_helper'

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  setup do
    @user = users(:default)
    sign_in @user
  end
  test 'it should render the show view' do
    get root_url

    assert_response :success

    assert_select 'h3', "Bonjour, #{@user.first_name.capitalize}"
  end

  test 'it should return the current yearly revenue' do
    current_yearly_revenue = @user.revenues.find_by(year: Time.zone.today.year).amount

    get root_url

    assert_response :success

    assert_select 'span', format_number_to_currency(current_yearly_revenue)
  end

  test 'it should return the current month income' do
    current_month_income = @user.activity_reports.find_by(
      start_date: Time.zone.today.beginning_of_month,
      end_date: Time.zone.today.end_of_month
    ).estimated_income

    get root_url

    assert_response :success

    assert_select 'span', format_number_to_currency(current_month_income)
  end

  test 'it should render the profitable statistic' do
    @user.update!(average_daily_rate: 800)
    @user.revenues.last.update!(amount: 77_000)

    get root_url

    assert_response :success

    assert_select 'span', text: 'Congé restants'
    assert_select 'span', text: 'Pour ne pas dépasser le plafond du CA'
    assert_select 'span', text: 'Gains manqués', count: 0
    assert_select 'span', text: 'Revenue potentiels non réalisés', count: 0
  end

  test 'it should not render the profitable statistic' do
    @user.update(average_daily_rate: 100)

    @user.revenues.last.update!(amount: 0)

    get root_url

    assert_response :success

    assert_select 'span', text: 'Gains manqués'
    assert_select 'span', text: 'Revenus potentiels non réalisés'
    assert_select 'span', text: 'Congé restants', count: 0
  end

  test "it should return a 500 error if there's no current yearly revenue" do
    @user.revenues.find_by(year: Time.zone.today.year).destroy!

    get root_url

    assert_response :internal_server_error
  end

  test "it should return a 500 error if there's noo current month income" do
    @user.activity_reports.find_by(
      start_date: Time.zone.today.beginning_of_month,
      end_date: Time.zone.today.end_of_month
    ).destroy!

    get root_url

    assert_response :internal_server_error
  end
end
