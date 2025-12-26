# frozen_string_literal: true

class ActivityReport < ApplicationRecord
  include ActivityReportDetails

  AVERAGE_TAX_ON_INCOME = 21.3

  belongs_to :user

  validates :start_date, uniqueness: { scope: %i[end_date user_id] }

  scope :from_this_month, -> { where(start_date: Date.current.beginning_of_month..) }
  scope :before_this_month, -> { where(start_date: ...Date.current.beginning_of_month) }

  def total_worked_days
    details['total_worked_days'] || 0
  end

  def estimated_income
    details['estimated_income'] || 0
  end

  def monthly_revenue
    details['monthly_revenue'] || 0
  end

  def days
    details['days'] || []
  end

  def update_average_daily_rate
    days.each do |day|
      next if Date.parse(day['date']) < Date.current

      day['rate'] = user.average_daily_rate
    end
    save!
  end
end
