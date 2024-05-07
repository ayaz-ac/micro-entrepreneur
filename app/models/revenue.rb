# frozen_string_literal: true

class Revenue < ApplicationRecord
  belongs_to :user

  validates :year, presence: true, numericality: { only_integer: true }

  MAX_PER_YEAR = 77_700
end
