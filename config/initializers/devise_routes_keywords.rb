# frozen_string_literal: true

# This is workaround to disable "DEPRECATION WARNING" on devise routing.
# The deprecation will normally be over with Devise v5.0
# Source: https://github.com/heartcombo/devise/issues/5735

ActionDispatch::Routing::Mapper.class_eval do
  protected

  def devise_registration(mapping, controllers) # rubocop:disable Metrics/MethodLength
    path_names = {
      new: mapping.path_names[:sign_up],
      edit: mapping.path_names[:edit],
      cancel: mapping.path_names[:cancel]
    }

    resource :registration,
             only: %i[new create edit update destroy],
             path: mapping.path_names[:registration],
             path_names: path_names,
             controller: controllers[:registrations] do
      get :cancel
    end
  end
end
