# frozen_string_literal: true

class ConfiguredOffDay < ApplicationRecord
  enum :day_of_week, %i[monday tuesday wednesday thursday friday saturday sunday]
  belongs_to :user
end
