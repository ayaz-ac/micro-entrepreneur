# frozen_string_literal: true

module ActivityReportDetails
  extend ActiveSupport::Concern

  included do
    after_validation :initialize_details
    before_save :count_total_worked_days
    before_save :calculate_monthly_revenue
    before_save :calculate_estimated_income
  end

  def update_days_status_in_details
    details['days'].each do |day|
      if off_day?(day['date'])
        day['status'] = 'off'
      elsif day['status'] == 'off'
        day['status'] = 'full'
      end
    end
    save!
    self
  end

  private

  def initialize_details
    return unless details.empty?

    self.details = { 'days' => [], 'total_worked_days' => 0, 'monthly_revenue' => 0, 'estimated_income' => 0 }

    (start_date.to_date..end_date.to_date).each do |day|
      details['days'] << {
        'date' => day,
        'status' => off_day?(day) ? 'off' : 'full',
        'rate' => user.average_daily_rate
      }
    end
  end

  def count_total_worked_days
    total_worked_days = 0

    details['days'].each do |day|
      next if day['status'] == 'off'

      total_worked_days += day['status'] == 'full' ? 1 : 0.5
    end
    details['total_worked_days'] = total_worked_days
  end

  def calculate_monthly_revenue
    details['days'].each do |day|
      next if day['status'] == 'off'

      details['monthly_revenue'] += day['status'] == 'full' ? day['rate'] : 0.5 * day['rate']
    end
  end

  def calculate_estimated_income
    details['estimated_income'] = details['monthly_revenue'] * ((100 - ActivityReport::AVERAGE_TAX_ON_INCOME) / 100)
  end

  def off_day?(day)
    off_days.include?(lowercase_weekday(day))
  end

  def off_days
    @off_days ||= user.configured_off_days_of_week
  end

  def lowercase_weekday(date)
    date = Date.parse(date) if date.is_a? String
    date.strftime('%A').downcase
  end
end
