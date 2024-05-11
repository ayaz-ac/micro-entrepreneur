# frozen_string_literal: true

require 'test_helper'

class ActivityReportTest < ActiveSupport::TestCase
  test 'it should copy the average_daily_rate from the user when a user is created' do
    assert_difference -> { ActivityReport.count }, (12 - Time.zone.today.month + 1) do
      create_user
      user = User.last

      user.activity_reports.each do |activity_report|
        assert_equal user.average_daily_rate, activity_report.average_daily_rate
      end
    end
  end

  test 'it should initialize the details when creating an ActivityReport' do
    create_user

    user = User.last

    user.activity_reports.each do |activity_report|
      assert activity_report.details.key?('days')
      assert activity_report.details.key?('total_worked_days')
      assert activity_report.details.key?('monthly_revenue')
      assert activity_report.details.key?('estimated_income')
      (activity_report.start_date.to_date..activity_report.end_date.to_date).each do |day|
        date = activity_report.details['days'].select { |d| d['date'] == day.strftime('%Y-%m-%d') }

        assert_equal 1, date.length
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
