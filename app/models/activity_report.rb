# frozen_string_literal: true

class ActivityReport < ApplicationRecord
  belongs_to :user

  validates :start_date, uniqueness: { scope: %i[end_date user_id] }
  validate :dates_in_same_month_and_year

  private

  def dates_in_same_month_and_year
    return unless start_date.present? && end_date.present?

    return if start_date.month == end_date.month && start_date.year == end_date.year

    errors.add(:base, 'Les dates doivent être dans le même mois et la même année')
  end
end
