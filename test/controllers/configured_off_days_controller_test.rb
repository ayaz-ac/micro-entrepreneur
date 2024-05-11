# frozen_string_literal: true

require 'test_helper'

class ConfiguredOffDaysControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:default)
    sign_in @user

    @user.update!(average_daily_rate: 500)
  end

  test 'it should update configured off days' do
    existing_configured_days = @user.configured_off_days_of_week
    new_configured_days = %w[monday tuesday] << existing_configured_days.first

    assert_changes -> { @user.configured_off_days.count } do
      patch configured_off_days_url(params: {
                                      user: {
                                        activity_report_id: @user.activity_reports.first.id,
                                        configured_off_days: new_configured_days
                                      }
                                    }, format: :turbo_stream)
      assert_response :success

      @user.reload

      assert new_configured_days.sort == @user.configured_off_days_of_week.sort
    end
  end

  test 'it should remove existing configured off days' do
    assert_changes -> { @user.configured_off_days.empty? } do
      patch configured_off_days_url(params: {
                                      user: {
                                        activity_report_id: @user.activity_reports.first.id,
                                        configured_off_days: %w[]
                                      }
                                    }, format: :turbo_stream)

      assert_response :success

      @user.reload
    end
  end

  test 'it should add a new configured off day' do
    assert_difference -> { @user.configured_off_days.count } do
      new_configured_days = @user.configured_off_days_of_week << 'monday'

      patch configured_off_days_url(params: {
                                      user: {
                                        activity_report_id: @user.activity_reports.first.id,
                                        configured_off_days: new_configured_days
                                      }
                                    }, format: :turbo_stream)

      assert_response :success

      @user.reload
    end
  end
end
