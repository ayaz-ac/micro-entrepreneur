# frozen_string_literal: true

class ActivityReport < ApplicationRecord
  include ActivityReportDetails

  belongs_to :user

  validates :start_date, uniqueness: { scope: %i[end_date user_id] }
  validates :average_daily_rate, presence: true
  validate :dates_in_same_month_and_year

  before_save :copy_average_daily_rate_from_user

  def total_worked_days
    details['total_worked_days'] || 0
  end

  def estimated_income
    details['estimated_income'] || 0
  end

  def days
    details['days'] || []
  end

  private

  def dates_in_same_month_and_year
    return unless start_date.present? && end_date.present?

    return if start_date.month == end_date.month && start_date.year == end_date.year

    errors.add(:base, 'Les dates doivent être dans le même mois et la même année')
  end

  def copy_average_daily_rate_from_user
    return if average_daily_rate == user.average_daily_rate

    self.average_daily_rate = user.average_daily_rate
  end
end
