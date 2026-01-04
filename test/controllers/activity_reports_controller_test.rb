# frozen_string_literal: true

require 'test_helper'

class ActivityReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:default)
    sign_in @user
  end

  test 'it should not render the show view if the user is not logged' do
    sign_out @user

    get activity_reports_url

    assert_redirected_to new_user_session_path
  end
  test 'it should render the show view for the current month' do
    get activity_reports_url

    assert_response :success

    assert_select 'span', text: (I18n.l Time.zone.today, format: '%B %Y')
  end

  test 'it should render the show view for another month' do
    date = Time.zone.local(Time.zone.now.year, rand(1..12))

    get activity_reports_url(params: { date: })

    assert_response :success

    assert_select 'span', text: (I18n.l date, format: '%B %Y')
  end
end
