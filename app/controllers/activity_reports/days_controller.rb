# frozen_string_literal: true

module ActivityReports
  class DaysController < ApplicationController
    before_action :authenticate_user!
    before_action :find_activity_report

    def update
      @activity_report.days.each do |day|
        next unless day['date'] == day_params[:date]

        day['status'] = day_params['status']
      end

      @activity_report.update_extras
      @activity_report.save!
    end

    private

    def day_params
      params.require(:day).permit(:date, :status)
    end

    def find_activity_report
      @activity_report = current_user.activity_reports.find(params[:activity_report_id])
    end
  end
end
