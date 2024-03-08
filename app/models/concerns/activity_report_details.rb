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

  def update_extras
    count_total_worked_days
    calculate_estimated_income
  end

  def count_total_worked_days
    details['total_worked_days'] = details['days'].count { |day| day['status'] != 'off' }
  end

  def calculate_estimated_income
    # TODO: Call URSSAF Api
    details['estimated_income'] = 400 * total_worked_days
  end

  def off_days
    @off_days ||= user.configured_off_days_of_week
  end

  def lowercase_weekday(date)
    date = Date.parse(date) if date.is_a? String
    date.strftime('%A').downcase
  end
end
