# frozen_string_literal: true

class Revenue < ApplicationRecord
  MAX_PER_YEAR = 77_700

  belongs_to :user

  validates :year, presence: true, numericality: { only_integer: true }
  validates :year, uniqueness: { scope: :user_id }
end
