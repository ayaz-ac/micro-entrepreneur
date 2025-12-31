# frozen_string_literal: true

return unless Rails.env.development?

User.destroy_all

# NOTE: after_create callbacks will automatically:
# - Create configured_off_days for Saturday and Sunday
# - Create activity_reports for remaining months of current year
@user = User.create!(
  email: 'user@example.com',
  password: 'password',
  first_name: 'John',
  last_name: 'Doe',
  average_daily_rate: 500,
  created_at: Date.current.beginning_of_year # Show calendar navigation
)

# Create revenue record for current year
revenue = @user.revenues.create!(
  year: Time.zone.today.year,
  amount: 0.00 # Will be calculated from activity reports
)

# Create activity reports with revenue data for all 12 months
current_year = Time.zone.today.year
current_month = Time.zone.today.month

(1..12).each do |month|
  start_date = Date.new(current_year, month, 1)
  end_date = start_date.end_of_month

  # Generate random worked days for past/current months, 0 for future months
  is_past_or_current = month <= current_month
  target_worked_days = is_past_or_current ? rand(10..22) : 0

  # Find or create activity report for this month
  activity_report = @user.activity_reports.find_or_initialize_by(
    start_date: start_date,
    end_date: end_date
  )

  # Build days array with proper status field
  days = []
  worked_days_added = 0

  (start_date..end_date).each do |date|
    # Determine status based on day type and worked days count
    if worked_days_added < target_worked_days
      status = 'full'
      worked_days_added += 1
    else
      status = 'off'
    end

    days << {
      'date' => date.to_s,
      'status' => status,
      'rate' => @user.average_daily_rate
    }
  end

  # Set details - the callbacks will calculate total_worked_days, monthly_revenue, and estimated_income
  activity_report.details = {
    'days' => days,
    'total_worked_days' => 0,
    'monthly_revenue' => 0,
    'estimated_income' => 0
  }

  activity_report.save!

  # Add to total revenue (now calculated by the model)
  revenue.amount += activity_report.details['monthly_revenue']
end

revenue.save!
