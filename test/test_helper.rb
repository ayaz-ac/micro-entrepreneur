# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def create_activity_report_for_the_current_month(user)
      assert_difference -> { ActivityReport.count } do
        get root_path
      end

      @activity_report = user.activity_reports.first
    end

    def create_activity_report_for_another_month(date)
      assert_difference -> { ActivityReport.count } do
        get root_path(date:)
      end
    end
  end
end
