# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    layout 'landing', only: %i[new create]
  end
end
