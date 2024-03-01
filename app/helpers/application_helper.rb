# frozen_string_literal: true

module ApplicationHelper
  def month_offset(date)
    date.wday - 1
  end
end
