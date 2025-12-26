# frozen_string_literal: true

class RemoveAverageDailyRateFromActivity < ActiveRecord::Migration[7.1]
  def change
    remove_column :activity_reports, :average_daily_rate, :integer
  end
end
