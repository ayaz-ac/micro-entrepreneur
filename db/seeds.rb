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
  average_daily_rate: 500 # Must be >= 100
)

# Create revenue record for current year
revenue = @user.revenues.create!(
  year: Time.zone.today.year,
  amount: 0.00 # Will be calculated from activity reports
)

# Create activity reports with revenue data from January to current month
current_year = Time.zone.today.year
current_month = Time.zone.today.month

(1..current_month).each do |month|
  start_date = Date.new(current_year, month, 1)
  end_date = start_date.end_of_month

  # Generate random worked days (between 10 and 22 days per month)
  worked_days = rand(10..22)

  # Calculate monthly revenue based on worked days and average daily rate
  monthly_revenue = worked_days * @user.average_daily_rate
  estimated_income = monthly_revenue * (1 - ActivityReport::AVERAGE_TAX_ON_INCOME / 100)

  # Find or create activity report for this month
  activity_report = @user.activity_reports.find_or_initialize_by(
    start_date: start_date,
    end_date: end_date
  )

  # Build days array with revenue data
  days = []
  (start_date..end_date).each do |date|
    next if date.saturday? || date.sunday? # Skip configured off days
    next if days.count >= worked_days # Only add up to worked_days

    days << {
      'date' => date.to_s,
      'rate' => @user.average_daily_rate,
      'worked' => true
    }
  end

  activity_report.details = {
    'total_worked_days' => worked_days,
    'estimated_income' => estimated_income,
    'monthly_revenue' => monthly_revenue,
    'days' => days
  }

  activity_report.save!

  # Add to total revenue
  revenue.amount += monthly_revenue
end

revenue.save!
