# frozen_string_literal: true

class DashboardsController < AuthenticatedController
  before_action :set_current_yearly_revenue
  before_action :set_estimated_yearly_revenue
  before_action :set_current_month_income

  def show
    @profitable = @estimated_yearly_revenue + current_user.average_daily_rate > Revenue::MAX_PER_YEAR
    if @profitable
      @off_days = ((@estimated_yearly_revenue - Revenue::MAX_PER_YEAR) / current_user.average_daily_rate).ceil
    else
      @missed_revenue = Revenue::MAX_PER_YEAR - @estimated_yearly_revenue
    end
  end

  private

  def set_current_yearly_revenue
    @current_yearly_revenue = current_user.revenues.find_by!(year: Time.zone.today.year).amount
  rescue ActiveRecord::RecordNotFound
    render file: 'public/500.html', status: :internal_server_error, layout: false
  end

  def set_estimated_yearly_revenue
    @estimated_yearly_revenue = @current_yearly_revenue + current_user.activity_reports.from_this_month
                                                                      .sum(&:monthly_revenue)
  end

  def set_current_month_income
    @current_month_income = current_user.activity_reports.find_by!(
      start_date: Time.zone.today.beginning_of_month,
      end_date: Time.zone.today.end_of_month
    ).estimated_income
  rescue ActiveRecord::RecordNotFound
    render file: 'public/500.html', status: :internal_server_error, layout: false
  end
end
