# frozen_string_literal: true

class AddStripeIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :stripe_id, :string
    add_index :users, :stripe_id, unique: true
  end
end
