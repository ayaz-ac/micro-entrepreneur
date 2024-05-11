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

  test "it should return a 500 error if there's no current yearly revenue" do
    @user.revenues.find_by(year: Time.zone.today.year).destroy!

    get root_url

    assert_response 500
  end

  test "it should return a 500 erro if there's noo current month income" do
    @user.activity_reports.find_by(
      start_date: Time.zone.today.beginning_of_month,
      end_date: Time.zone.today.end_of_month
    ).destroy!

    get root_url

    assert_response 500
  end
end
