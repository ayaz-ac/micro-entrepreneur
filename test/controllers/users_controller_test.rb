# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'it should render the edit view if the user is authenticated' do
    @user = users(:default)
    sign_in @user

    get edit_user_registration_url

    assert_response :success
  end

  test 'it should update the password if it is in the params and the user is authenticated' do
    @user = users(:default)
    sign_in @user

    patch user_registration_url(params: {
                                  user: {
                                    current_password: 'password',
                                    password: 'testpassword',
                                    password_confirmation: 'testpassword'
                                  }
                                })

    assert_redirected_to root_url

    follow_redirect!
    assert_redirected_to dashboards_path
  end
  test 'it should update the average daily rate if the user is authenticated' do
    @user = users(:default)
    sign_in @user

    assert_changes -> { @user.average_daily_rate } do
      patch average_daily_rate_url(params: {
                                     user: {
                                       average_daily_rate: 800
                                     }
                                   }, format: :turbo_stream)

      assert_response :success

      @user.reload
    end
  end

  test 'it should not render the edit view if the user is not authenticated' do
    get edit_user_registration_url

    assert_redirected_to new_user_session_path
  end

  test 'it should not update if the user is not authenticated' do
    patch user_registration_url(params: { user: { average_daily_rate: 800 } })

    assert_redirected_to new_user_session_path
  end
end
