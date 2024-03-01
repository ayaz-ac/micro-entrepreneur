# frozen_string_literal: true

class ActivityReportsController < ApplicationController
  def show
    @date = Date.parse(params.fetch(:date, Time.zone.today.to_s)).at_beginning_of_month
  end
end
