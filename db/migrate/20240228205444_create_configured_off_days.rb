# frozen_string_literal: true

class CreateConfiguredOffDays < ActiveRecord::Migration[7.1]
  def change
    create_table :configured_off_days do |t|
      t.integer :day_of_week
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
