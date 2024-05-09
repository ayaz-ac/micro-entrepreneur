# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'it should not create user with a wrong average_daily_rate' do
    user = User.new(first_name: 'John', last_name: 'Doe', email: 'user.test@example.com', password: 'password')

    assert_not user.valid?
    assert_equal ['TJM doit être rempli(e)', "TJM n'est pas un nombre"], user.errors.full_messages

    user.average_daily_rate = 99

    assert_not user.valid?
    assert_equal 'TJM doit être supérieur ou égal à 100', user.errors.full_messages.first
  end

  test "it shouldn't create a user without a first and last name" do
    user = User.new(average_daily_rate: 450, email: 'user.test@example.com', password: 'password')

    assert_not user.valid?
    assert_equal ['Prénom doit être rempli(e)', 'Nom doit être rempli(e)'], user.errors.full_messages
  end
end
