# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :average_daily_rate, presence: true

  has_many :activity_reports, dependent: :destroy
  has_many :configured_off_days, dependent: :destroy

  after_create :create_default_configured_off_days
  # after_update :copy_and_update_average_daily_rate_in_activity_reports, if: :saved_change_to_average_daily_rate?

  def configured_off_days_of_week
    configured_off_days.map(&:day_of_week)
  end

  private

  def create_default_configured_off_days
    %w[saturday sunday].each do |day_of_week|
      configured_off_days.create!(day_of_week:)
    end
  end

  # def copy_and_update_average_daily_rate_in_activity_reports
  #   activity_reports_to_update = activity_reports.from_this_month

  #   activity_reports_to_update.update_all(average_daily_rate:) # rubocop:disable Rails/SkipsModelValidations
  #   activity_reports_to_update.each do |activity_report|
  #     activity_report.calculate_estimated_income
  #     activity_report.save!
  #   end
  # end
end
