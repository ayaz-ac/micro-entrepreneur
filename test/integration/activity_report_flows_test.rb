# frozen_string_literal: true

require 'test_helper'

class ActivityReportFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:default)

    # Trigger after_validation :initialize_details in ActivityReportDetails
    @user.update!(average_daily_rate: 500)

    sign_in @user
  end

  test 'it should update the status of only one day for the current month ActivityReport' do
    @activity_report = @user.activity_reports.find_by(
      start_date: Time.zone.today.at_beginning_of_month,
      end_date: Time.zone.today.end_of_month
    )

    %w[half full off].each do |status|
      previous_estimated_income = @activity_report.estimated_income

      assert_changes -> { @activity_report.total_worked_days } do
        put activity_report_days_path(@activity_report),
            params: { day: { date: Time.zone.today.to_s, status: }, format: :turbo_stream }
        @activity_report.reload
      end

      assert_not_equal previous_estimated_income, @activity_report.estimated_income
    end
  end
end
