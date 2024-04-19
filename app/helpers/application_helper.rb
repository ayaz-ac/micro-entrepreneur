# frozen_string_literal: true

module ApplicationHelper
  def active_class(link_path, css_class)
    current_page?(link_path) ? css_class : ''
  end
end
