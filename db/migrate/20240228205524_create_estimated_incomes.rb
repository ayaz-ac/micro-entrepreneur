# frozen_string_literal: true

class CreateEstimatedIncomes < ActiveRecord::Migration[7.1]
  def change
    create_table :estimated_incomes do |t|
      t.integer :month
      t.integer :year
      t.decimal :amount
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
