# frozen_string_literal: true

module ActivityReportHelper
  def actual_month?(date)
    today = Time.zone.today

    date.year == today.year && date.month == today.month
  end

  def month_offset(date)
    return 6 if date.wday.zero?

    date.wday - 1
  end

  def month_inset(date)
    return 0 if date.end_of_month.wday.zero?

    7 - date.end_of_month.wday
  end

  def status_class(status)
    day_class = case status
                when 'full'
                  'bg-green-100'
                when 'half'
                  'bg-yellow-100'
                else
                  'bg-red-100'
                end
    "border-gray-300 #{day_class}"
  end

  def today?(day)
    day == Time.zone.today.to_datetime
  end
end
