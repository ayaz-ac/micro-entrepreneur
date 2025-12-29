# frozen_string_literal: true

module ActivityReportHelper
  def previous_month?(date)
    today = Time.zone.today

    date.year <= today.year && date.month < today.month
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
    case status
    when 'full'
      'bg-emerald-400'
    when 'half'
      'bg-amber-300'
    else
      'bg-gray-300'
    end
  end

  def today?(day)
    day == Time.zone.today.strftime('%Y-%m-%d')
  end
end
