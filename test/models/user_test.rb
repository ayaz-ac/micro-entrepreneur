# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'it should create a user with default values' do
    @user = User.create!(email: 'test@example.com', password: 'password')

    assert_equal 0, @user.average_daily_rate
    assert_equal %w[saturday sunday], @user.configured_off_days.map(&:day_of_week)
  end
end
