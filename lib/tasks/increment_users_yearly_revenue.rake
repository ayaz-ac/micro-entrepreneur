# frozen_string_literal: true

desc 'Increments every month the users yearly revenue'

task increment_users_yearly_revenue: :environment do
  User.find_each do |user|
    user_on_going_yearly_revenue = user.revenues.find_by(year: Time.zone.now.year)
    user_previous_month_revenue = user.activity_reports.find_by(
      start_date: Time.zone.now.prev_month.at_beginning_of_month, end_date: Time.zone.now.prev_month.at_end_of_month
    )&.monthly_revenue

    next unless user_previous_month_revenue

    user_on_going_yearly_revenue.update!(
      amount: user_on_going_yearly_revenue.amount + user_previous_month_revenue
    )
  end
end
