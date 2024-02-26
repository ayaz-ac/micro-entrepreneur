# frozen_string_literal: true

return unless Rails.env.development?

User.destroy_all

User.create!(email: 'user@example.com', password: 'password')
