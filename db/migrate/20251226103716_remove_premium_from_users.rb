# frozen_string_literal: true

class RemovePremiumFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :premium, :boolean
  end
end
