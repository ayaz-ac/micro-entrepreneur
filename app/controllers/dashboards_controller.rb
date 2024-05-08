# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :set_revenue
  before_action :set_estimated_revenue
  before_action :set_current_month_income

  def show
    @worth = @estimated_income + current_user.average_daily_rate > Revenue::MAX_PER_YEAR
    return if @worth

    @missed_revenue = Revenue::MAX_PER_YEAR - @estimated_income
  end

  private

  def set_revenue
    @revenue = current_user.revenues.find_by(year: Time.zone.now.year)
  end

  def set_estimated_revenue
    @estimated_income = @revenue.amount + current_user.activity_reports.from_this_month.sum(&:income_before_tax)
  end

  def set_current_month_income
    @current_month_income = current_user.activity_reports.find_by(
      start_date: Time.zone.now.at_beginning_of_month,
      end_date: Time.zone.now.at_end_of_month
    ).estimated_income
  end
end
