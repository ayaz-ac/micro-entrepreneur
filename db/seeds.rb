# frozen_string_literal: true

return unless Rails.env.development?

User.destroy_all

@user = User.create!(email: 'user@example.com', password: 'password')

%w[saturday sunday].each do |day_of_week|
  @user.configured_off_days.create!(day_of_week:)
end
