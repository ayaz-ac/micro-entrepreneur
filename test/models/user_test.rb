# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'it should create a user with default values' do
    @user = User.create!(email: 'test@example.com', password: 'password')

    assert_equal @user.average_daily_rate, 0
    assert_equal @user.configured_off_days.map(&:day_of_week), %w[saturday sunday]
  end
end
