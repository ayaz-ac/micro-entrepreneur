# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:default)
    sign_in @user

    @user.update!(average_daily_rate: 500)
  end

  test 'it should update a day status' do
    @activity_report = @user.activity_reports.find_by(start_date: Time.zone.today.beginning_of_month)

    day_status = @activity_report.details['days'].find { |day| day['date'] == Time.zone.today.strftime('%Y-%m-%d') }

    assert_changes -> { day_status } do
      patch activity_report_days_url(activity_report_id: @activity_report.id,
                                     params: { day: { date: Time.zone.today.strftime('%Y-%m-%d'),
                                                      status: 'half' } }, format: :turbo_stream)
      assert_response :success

      @activity_report.reload

      day_status = @activity_report.details['days'].find { |day| day['date'] == Time.zone.today.strftime('%Y-%m-%d') }
    end
  end
end
