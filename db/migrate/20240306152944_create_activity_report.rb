# frozen_string_literal: true

class CreateActivityReport < ActiveRecord::Migration[7.1]
  def change
    create_table :activity_reports do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.jsonb :details, default: {}
      t.integer :average_daily_rate, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :activity_reports, %i[start_date end_date user_id], unique: true
  end
end
