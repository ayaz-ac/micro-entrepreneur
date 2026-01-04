# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    layout 'landing', only: %i[new create]

    private

    def account_update_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation,
                                   :current_password)
    end
  end
end
