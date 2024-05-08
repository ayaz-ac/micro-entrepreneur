# frozen_string_literal: true

class CreateRevenue < ActiveRecord::Migration[7.1]
  def change
    create_table :revenues do |t|
      t.integer :year, null: false, default: Time.zone.now.year
      t.decimal :amount, default: 0

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :revenues, %i[year user_id], unique: true
  end
end
