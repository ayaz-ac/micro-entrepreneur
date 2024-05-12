# frozen_string_literal: true

class ActivityReportsController < ApplicationController
  before_action :find_activity_report

  def show; end

  private

  def find_activity_report
    @activity_report = current_user.activity_reports.find_by!(start_date:)
  end

  def start_date
    Time.zone.parse(params.fetch(:date, Time.zone.today.to_s)).at_beginning_of_month
  end
end
