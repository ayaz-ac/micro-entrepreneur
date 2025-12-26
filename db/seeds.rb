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

@user.revenues.create!(
  year: Time.zone.today.year,
  amount: 45_000.00
)
