# frozen_string_literal: true

require 'test_helper'

class DeviseFlowsTest < ActionDispatch::IntegrationTest
  test 'it should login user with correct credentials' do
    user = users(:default)

    # Trigger after_validation :initialize_details in ActivityReportDetails
    user.update!(average_daily_rate: 500) 

    post user_session_path, params: { user: { email: user.email, password: 'password' } }

    assert_redirected_to root_path
    follow_redirect!

    assert_response :success
    assert_select 'div', 'Connecté(e).'
  end

  test 'it should fail user login with incorrect credentials' do
    post user_session_path, params: { user: { email: 'invalid@example.com', password: 'wrong_password' } }

    assert_response :unprocessable_entity
    assert_select 'div', 'E-mail ou mot de passe incorrect.'
  end

  test 'it should send a e-mail when requesting a password reset' do
    user = users(:default)
    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      post user_password_path, params: { user: { email: user.email } }
    end

    assert_redirected_to new_user_session_path
    assert_equal 'Vous allez recevoir sous quelques minutes un email vous indiquant comment réinitialiser votre ' \
                 'mot de passe.', flash[:notice]
  end

  test 'it should reset password successfully' do
    user = users(:default)
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    user.update!(reset_password_token: hashed, reset_password_sent_at: Time.zone.now)

    new_password = 'new_password'

    put user_password_path, params: {
      user: {
        reset_password_token: raw,
        password: new_password,
        password_confirmation: new_password
      }
    }

    assert_redirected_to root_path
    assert_equal 'Votre mot de passe a bien été modifié. Vous êtes maintenant connecté(e).', flash[:notice]
  end
end
