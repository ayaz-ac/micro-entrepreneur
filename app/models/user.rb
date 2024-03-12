# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :average_daily_rate, presence: true

  has_many :activity_reports, dependent: :destroy
  has_many :configured_off_days, dependent: :destroy
  has_many :work_days, dependent: :destroy

  def configured_off_days_of_week
    configured_off_days.map(&:day_of_week)
  end
end
