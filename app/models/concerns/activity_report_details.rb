# frozen_string_literal: true

module ActivityReportDetails
  extend ActiveSupport::Concern

  included do
    before_create :initialize_details
  end

  def total_worked_days
    details['total_worked_days']
  end

  def update_off_days_in_details
    details['days'].each do |day|
      day_name = Date.parse(day['date']).strftime('%A').downcase

      if off_days.any? day_name
        day['status'] = 'off'
      elsif day['status'] == 'off'
        day['status'] = 'full'
      end
    end

    count_total_worked_days

    save!
  end

  private

  def initialize_details
    self.details = { 'days' => [], 'total_worked_days' => 0 }

    (start_date.to_date..end_date.to_date).each do |day|
      details['days'] << {
        'date' => day,
        'status' => day_off?(off_days, day) ? 'off' : 'full'
      }
    end

    count_total_worked_days
  end

  def day_off?(off_days, day)
    off_days.any? day.strftime('%A').downcase
  end

  def count_total_worked_days
    details['total_worked_days'] = details['days'].count { |day| day['status'] != 'off' }
  end

  def off_days
    @off_days ||= user.configured_off_days_of_week
  end
end
