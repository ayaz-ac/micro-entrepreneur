# frozen_string_literal: true

class ActivityReportsController < ApplicationController
  def show
    @date = Date.parse(params.fetch(:date, Time.zone.today.to_s)).at_beginning_of_month
    @off_days = current_user.configured_off_days
  end
end
