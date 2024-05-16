# frozen_string_literal: true

require 'test_helper'

class SignUpFlowsTest < ActionDispatch::IntegrationTest
  test 'it should not create a user without the average daily rate' do
    post user_registration_path, params: { user: user_params(nil) }

    assert_response :unprocessable_entity
    assert_includes response.body, 'TJM doit être rempli(e)'
  end

  test 'it should not create a user with a invalid average daily rate' do
    post user_registration_path, params: { user: user_params('abc') }

    assert_response :unprocessable_entity
    assert_includes response.body, 'TJM n&#39;est pas un nombre'
  end

  test "it should not sign up user if the average daily rate is below #{User::AVERAGE_DAILY_RATE_LIMIT}" do
    assert_no_changes -> { User.all.size } do
      post user_registration_path, params: { user: user_params(50) }

      assert_response :unprocessable_entity
      assert_includes response.body, 'une erreur a empêché ce (cet ou cette) utilisateur d’être enregistré(e)'
      assert_includes response.body, 'TJM doit être supérieur ou égal à 100'
    end
  end

  test 'it should create a user' do
    assert_difference -> { User.count } do
      post user_registration_path, params: { user: user_params }

      assert_response :redirect
      follow_redirect!
    end
  end

  private

  def user_params(average_daily_rate = 400)
    {
      first_name: 'John',
      last_name: 'Doe',
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password',
      revenues_attributes: { 0 => { amount: '35000' } },
      average_daily_rate:
    }
  end
end
