# frozen_string_literal: true

class TailwindBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {})
    if text.is_a?(Hash)
      options = text
      text = nil
    end

    options[:class] = [options[:class], 'block text-gray-900 mb-1 md:mb-0'].compact.join(' ')
    super
  end

  %i[datetime_field date_field text_field email_field password_field number_field].each do |field_type|
    define_method(field_type) do |method, options = {}|
      options.reverse_merge!({ class: field_css_classes(method) })
      field_html = super(method, options)
      add_error_message_if_needed(field_html, method)
    end
  end

  def file_field(method, options = {})
    options = options.reverse_merge!({ class: field_css_classes(method) })
    field_html = super
    add_error_message_if_needed(field_html, method)
  end

  def select(method, choices = nil, options = {}, html_options = {}, &)
    html_options[:class] = [html_options[:class], field_css_classes(method)].compact.join(' ')
    field_html = super
    add_error_message_if_needed(field_html, method)
  end

  def time_select(method, options = {}, html_options = {}, &)
    html_options[:class] = [html_options[:class], field_css_classes(method)].compact.join(' ')
    field_html = super
    add_error_message_if_needed(field_html, method)
  end

  def check_box(method, options = {})
    super(method, options.reverse_merge({ class: 'rounded border-gray-300 text-secondary' }))
  end

  def submit(method, options = {})
    super(method, options.reverse_merge(
      { class: 'btn-cta' }
    ))
  end

  private

  def field_css_classes(method)
    base_classes = 'block w-full rounded-md focus:border-2 focus:ring-0 focus:outline-none'
    if object.errors[method].any?
      "#{base_classes} border-red-500"
    else
      "#{base_classes} border-gray-300 focus:border-brand-500"
    end
  end

  def add_error_message_if_needed(field_html, method)
    return field_html unless object.errors[method].any?

    error_message = @template.content_tag(:div, object.errors[method].first,
                                          class: 'text-red-600 text-sm mt-1')
    (field_html + error_message).html_safe # rubocop:disable Rails/OutputSafety
  end
end
