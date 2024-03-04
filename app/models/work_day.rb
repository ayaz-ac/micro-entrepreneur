# frozen_string_literal: true

class WorkDay < ApplicationRecord
  enum :status, %i[full half]

  belongs_to :user
end
