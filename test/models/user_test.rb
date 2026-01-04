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

  test 'it should create the default configured off days when creating a user' do
    assert_difference -> { ConfiguredOffDay.count }, 2 do
      create_user

      user = User.last

      assert_equal 'saturday', user.configured_off_days.first.day_of_week
      assert_equal 'sunday', user.configured_off_days.last.day_of_week
    end
  end

  test 'it should create activity_reports for the remaining months of this current year' do
    assert_difference -> { ActivityReport.count }, (12 - Time.zone.today.month + 1) do
      create_user
    end
  end

  test "it should copy the user's average_daily_rate into the current and on going activity reports" do
    user = users(:default)
    new_average_daily_rate = 800

    user.update!(average_daily_rate: new_average_daily_rate)

    user.activity_reports.from_this_month.each do |activity_report|
      activity_report.days.each do |day|
        assert_equal new_average_daily_rate, day['rate']
      end
    end

    user.activity_reports.before_this_month.each do |activity_report|
      activity_report.days.each do |day|
        assert_not_equal new_average_daily_rate, day['rate']
      end
    end
  end

  private

  def create_user
    @user = User.create!(
      first_name: 'John',
      last_name: 'Doe',
      email: 'user.test@example.com',
      password: 'password',
      average_daily_rate: 400,
      revenues_attributes: { 0 => { amount: '35000' } }
    )
  end
end
