# frozen_string_literal: true

class CreateWorkDays < ActiveRecord::Migration[7.1]
  def change
    create_table :work_days do |t|
      t.datetime :date
      t.integer :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
