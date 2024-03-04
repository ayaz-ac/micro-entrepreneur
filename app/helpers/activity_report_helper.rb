# frozen_string_literal: true

module ActivityReportHelper
  def month_offset(date)
    return 6 if date.wday.zero?

    date.wday - 1
  end

  def month_inset(date)
    return 0 if date.end_of_month.wday.zero?

    7 - date.end_of_month.wday
  end

  def previous_month?(date)
    today = Time.zone.today

    return date.year <= today.year && date.month < today.month if date.year == today.year

    return true if date.year < today.year

    false
  end

  def user_off?(off_days, day)
    off_days.map(&:day_of_week).any? day.strftime('%A').downcase
  end

  def today?(day)
    day == Time.zone.today
  end
end
