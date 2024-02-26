# frozen_string_literal: true

class StripeSetupGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  argument :mode, type: :string, default: 'subscription'

  def install
    gem 'stripe'
    run 'bundle'
  end

  def create_initializer
    copy_file 'initializer.rb', 'config/initializers/stripe.rb'
  end

  def run_migrations
    copy_file 'migrations/add_stripe_id_to_users.rb',
              "db/migrate/#{Time.zone.now.strftime('%Y%m%d%H%M%S')}_add_stripe_id_to_users.rb"

    if mode == 'subscription'
      copy_file 'migrations/add_premium_until_to_users.rb',
                "db/migrate/#{Time.zone.now.strftime('%Y%m%d%H%M%S')}_add_premium_until_to_users.rb"
    else
      copy_file 'migrations/add_premium_to_users.rb',
                "db/migrate/#{Time.zone.now.strftime('%Y%m%d%H%M%S')}_add_premium_to_users.rb"
    end

    run 'rails db:migrate'
  end

  def generate_controllers
    copy_file "controllers/#{mode}/checkout_sessions_controller.rb",
              'app/controllers/stripe/checkout_sessions_controller.rb'
    copy_file "controllers/#{mode}/webhooks_controller.rb",
              'app/controllers/stripe/webhooks_controller.rb'
  end

  def update_user_model
    inject_into_file 'app/models/user.rb', after: ':recoverable, :rememberable, :validatable' do
      <<~RUBY


        validates :stripe_id, presence: true, allow_blank: false, uniqueness: true
      RUBY
    end
  end

  def add_subscription_methods_to_user # rubocop:disable Metrics/MethodLength
    return if mode == 'payment'

    inject_into_file 'app/models/user.rb',
                     after: 'validates :stripe_id, presence: true, allow_blank: false, uniqueness: true' do
      <<~RUBY


        after_create :increment_premium

        def increment_premium
          self.premium_until = Time.zone.today if premium_until.nil? || (premium_until < Time.zone.today)
          self.premium_until += 1.month
        end

        def premium?
          return false if premium_until.nil?

          premium_until >= Time.zone.today
        end
      RUBY
    end
  end

  def update_routes
    inject_into_file 'config/routes.rb',
                     after: 'devise_for :users' do
      <<~RUBY

        namespace :stripe do
          resources :checkout_sessions, only: :create
          resource :webhook, only: :create
        end
      RUBY
    end
  end
end
