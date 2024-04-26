# frozen_string_literal: true

require 'test_helper'

class SignUpFlowsTest < ActionDispatch::IntegrationTest
  test 'it should not create a user without the average daily rate' do
    post user_registration_path, params: { user: { email: 'test@example.com', password: 'password', password_confirmation: 'password' } }

    assert_response :unprocessable_entity
    assert_includes response.body, 'TJM doit être rempli(e)'
  end

  test 'it should not create a user with a invalid average daily rate' do
    post user_registration_path, params: { user: { email: 'test@example.com', password: 'password', password_confirmation: 'password', average_daily_rate: 'abc' } }

    assert_response :unprocessable_entity
    assert_includes response.body, 'TJM n&#39;est pas un nombre'
  end

  test "it should not sign up user if the average daily rate is below #{User::AVERAGE_DAILY_RATE_LIMIT}" do
    assert_no_changes -> { User.all.size } do
      post user_registration_path,
           params: { user: { email: 'user.test@example.com', password: 'password', password_confirmation: 'password',
                             average_daily_rate: 50 } }

      assert_response :unprocessable_entity
      assert_includes response.body, 'une erreur a empêché ce (cet ou cette) utilisateur d’être enregistré(e)'
      assert_includes response.body, 'TJM doit être supérieur ou égal à 100' 
    end
  end

  test 'it should sign up user' do
    post user_registration_path, params: { user: { email: 'test@example.com', password: 'password', password_confirmation: 'password', average_daily_rate: 150 } }

    assert_response :redirect
    follow_redirect!

    assert_response :success
    assert_select 'div', 'Bienvenue ! Vous vous êtes bien enregistré(e).'
    assert_select 'a[href=?]', root_path
  end
end
