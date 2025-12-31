# frozen_string_literal: true

module MonthlyRevenueChart
  extend ActiveSupport::Concern

  def set_monthly_chart_data
    @monthly_revenue_chart_data = monthly_revenue_chart_data
    @monthly_revenue_chart_options = monthly_revenue_chart_options
  end

  def monthly_revenue_chart_data
    {
      labels: monthly_labels,
      datasets: [{
        label: 'Revenu mensuel estimé (€)',
        backgroundColor: 'oklch(52% 0.058 260)',
        data: monthly_reports.map(&:estimated_income)
      }]
    }
  end

  def monthly_revenue_chart_options # rubocop:disable Metrics/MethodLength
    {
      responsive: true,
      maintainAspectRatio: true,
      scales: {
        y: {
          beginAtZero: true
        }
      },
      plugins: {
        legend: {
          display: false
        },
        tooltip: {}
      }
    }
  end

  private

  def monthly_reports
    @monthly_reports ||= current_user.activity_reports
                                     .where(
                                       start_date: Date.current.beginning_of_year..Date.current.end_of_month
                                     )
                                     .order(:start_date)
  end

  def monthly_labels
    labels = []
    monthly_reports.each do |report|
      month_name = I18n.l(report.start_date, format: '%B')
      labels << month_name
    end
    labels
  end
end
