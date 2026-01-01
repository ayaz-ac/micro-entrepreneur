# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    layout 'landing', only: %i[new create]

    def update
      super do |resource|
        if resource.errors.empty?
          # Render the turbo frame on success
          return render :edit, status: :ok
        end
      end
    end
  end
end
