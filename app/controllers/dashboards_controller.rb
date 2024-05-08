# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :set_current_yearly_revenue
  before_action :set_estimated_yearly_revenue
  before_action :set_current_month_income

  def show
    @profitable = @estimated_yearly_revenue + current_user.average_daily_rate > Revenue::MAX_PER_YEAR
    return if @profitable

    @missed_revenue = Revenue::MAX_PER_YEAR - @estimated_yearly_revenue
  end

  private

  def set_current_yearly_revenue
    @current_yearly_revenue = current_user.revenues.find_by(year: Time.zone.now.year).amount
  end

  def set_estimated_yearly_revenue
    @estimated_yearly_revenue = @current_yearly_revenue + current_user.activity_reports.from_this_month
                                                                      .sum(&:monthly_revenue)
  end

  def set_current_month_income
    @current_month_income = current_user.activity_reports.find_by(
      start_date: Time.zone.now.at_beginning_of_month,
      end_date: Time.zone.now.at_end_of_month
    ).estimated_income
  end
end
