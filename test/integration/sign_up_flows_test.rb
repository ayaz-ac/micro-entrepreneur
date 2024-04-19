# frozen_string_literal: true

require 'test_helper'

class SignUpFlowsTest < ActionDispatch::IntegrationTest
  test "it should not sign up user if the average daily rate is below #{User::AVERAGE_DAILY_RATE_LIMIT}" do
    assert_no_changes -> { User.all.size } do
      post user_registration_path,
           params: { user: { email: 'user.test@example.com', password: 'password', password_confirmation: 'password',
                             average_daily_rate: 50 } }
      assert_includes response.body, 'une erreur a empêché ce (cet ou cette) utilisateur d’être enregistré(e)'
      assert_includes response.body, 'TJM doit être supérieur ou égal à 100' 
    end
  end
end
