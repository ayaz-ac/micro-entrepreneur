# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    layout 'landing', only: :new
  end
end
