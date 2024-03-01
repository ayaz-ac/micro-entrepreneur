# frozen_string_literal: true

module ApplicationHelper
  def month_offset(date)
    return 6 if date.wday.zero?

    date.wday - 1
  end

  def month_inset(date)
    return 0 if date.end_of_month.wday.zero?

    7 - date.end_of_month.wday
  end
end
