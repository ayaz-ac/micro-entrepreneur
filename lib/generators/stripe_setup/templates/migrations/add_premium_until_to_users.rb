# frozen_string_literal: true

class AddPremiumUntilToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :premium_until, :datetime, default: nil
  end
end
