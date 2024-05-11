require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'it should render the edit view if the user is authenticated' do
    @user = users(:default)
    sign_in @user

    get edit_user_url(@user)

    assert_response :success
  end

  test 'it should update the password if it is in the params and the user is authenticated' do
    @user = users(:default)
    sign_in @user

    patch user_url(id: @user.id,
                   params: {
                     user: {
                       current_password: 'password',
                       password: 'testpassword',
                       password_confirmation: 'testpassword'
                     }
                   })

    assert_redirected_to root_url

    follow_redirect!
    assert_select 'div', 'Votre profil a été mis à jour avec succès!'
  end
  test 'it should update everything except the password if the user is authenticated' do
    @user = users(:default)
    sign_in @user

    assert_changes -> { @user.average_daily_rate } do
      patch user_url(id: @user.id,
                     params: {
                       user: {
                         average_daily_rate: 800
                       }
                     })

      assert_redirected_to root_url

      follow_redirect!
      assert_select 'div', 'Votre profil a été mis à jour avec succès!'

      @user.reload
    end
  end

  test 'it should not render the edit view if the user is not authenticated' do
    get edit_user_url(id: users(:default))

    assert_response :missing
  end

  test 'it should not update if the user is not authenticated' do
    patch user_url(id: users(:default).id, params: { user: { average_daily_rate: 800 } })

    assert_response :missing
  end
end
