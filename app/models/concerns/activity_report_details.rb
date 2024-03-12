# frozen_string_literal: true

module ActivityReportDetails
  extend ActiveSupport::Concern

  included do
    before_create :initialize_details
  end

  def update_days_status_in_details
    details['days'].each do |day|
      if off_day?(day['date'])
        day['status'] = 'off'
      elsif day['status'] == 'off'
        day['status'] = 'full'
      end
    end

    update_extras
    save!
  end

  def update_extras
    count_total_worked_days
    calculate_estimated_income
  end

  private

  def initialize_details
    self.details = { 'days' => [], 'total_worked_days' => 0, 'estimated_income' => 0 }

    (start_date.to_date..end_date.to_date).each do |day|
      details['days'] << {
        'date' => day,
        'status' => off_day?(day) ? 'off' : 'full'
      }
    end

    update_extras
  end

  def off_day?(day)
    off_days.include?(lowercase_weekday(day))
  end

  def count_total_worked_days
    total_worked_days = 0

    details['days'].each do |day|
      next if day['status'] == 'off'

      total_worked_days += day['status'] == 'full' ? 1 : 0.5
    end
    details['total_worked_days'] = total_worked_days
  end

  def calculate_estimated_income
    revenue_before_urssaf_tax = average_daily_rate * total_worked_days
    details['estimated_income'] = ::UrssafManager::RevenueBeforeIncomeTax.call(revenue_before_urssaf_tax)
  rescue StandardError => e
    Rails.logger.error("Une erreur s'est produite lors du calcul de la rémunération pour l'utilisateur : #{e.message}")
    details['estimated_income'] = revenue_before_urssaf_tax
  end

  def off_days
    @off_days ||= user.configured_off_days_of_week
  end

  def lowercase_weekday(date)
    date = Date.parse(date) if date.is_a? String
    date.strftime('%A').downcase
  end
end
