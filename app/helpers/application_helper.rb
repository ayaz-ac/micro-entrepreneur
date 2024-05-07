# frozen_string_literal: true

module ApplicationHelper
  def active_class(link_path, css_class)
    current_page?(link_path) ? css_class : ''
  end

  def translate_year(date)
    I18n.l date, format: '%Y'
  end

  def translate_month(date)
    I18n.l date, format: '%B'
  end

  def translate_month_and_year(date)
    I18n.l date, format: '%B %Y'
  end

  def format_number_to_currency(amount)
    number_to_currency(amount, unit: '€', precision: 0, separator: ' ', delimiter: ' ')
  end
end
