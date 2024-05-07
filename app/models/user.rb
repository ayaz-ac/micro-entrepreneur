# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  AVERAGE_DAILY_RATE_LIMIT = 100

  validates :average_daily_rate, presence: true
  validates :average_daily_rate, numericality: { only_integer: true, greater_than_or_equal_to: AVERAGE_DAILY_RATE_LIMIT }

  has_many :activity_reports, dependent: :destroy
  has_many :configured_off_days, dependent: :destroy
  has_many :revenues, dependent: :destroy

  accepts_nested_attributes_for :revenues

  after_create :create_default_configured_off_days
  after_update :copy_average_daily_rate_into_activity_reports, if: :saved_change_to_average_daily_rate?

  def configured_off_days_of_week
    configured_off_days.reload.map(&:day_of_week)
  end

  private

  def create_default_configured_off_days
    %w[saturday sunday].each do |day_of_week|
      configured_off_days.create!(day_of_week:)
    end
  end

  def copy_average_daily_rate_into_activity_reports
    activity_reports.from_this_month.find_each { |activity_report| activity_report.update(average_daily_rate:) }
  end
end
