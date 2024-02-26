# frozen_string_literal: true

class AddPremiumToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :premium, :boolean, default: true, null: false
  end
end
