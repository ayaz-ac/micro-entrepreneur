# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :set_locale

  private

  def set_locale(&)
    locale = params[:locale] || extract_locale_from_accept_language_header
    locale = 'en' if locale.nil? || I18n.available_locales.exclude?(locale.to_sym)
    I18n.with_locale(locale, &)
  end

  def extract_locale_from_accept_language_header
    return if request.env['HTTP_ACCEPT_LANGUAGE'].nil?

    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
