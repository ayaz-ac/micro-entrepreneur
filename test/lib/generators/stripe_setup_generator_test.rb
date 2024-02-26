# frozen_string_literal: true

require 'test_helper'
require 'generators/stripe_setup/stripe_setup_generator'

class StripeSetupGeneratorTest < Rails::Generators::TestCase
  tests StripeSetupGenerator
  destination Rails.root.join('tmp/generators')
  setup do
    prepare_destination
    create_files
  end

  PATH = 'tmp/generators'

  test 'it should generate stripe configuration for both modes' do
    run_generator

    assert_file 'config/initializers/stripe.rb', /Stripe.api_key/
    assert_migrations
    assert_model
    assert_controllers
    assert_routes
  end

  test 'it should generate stripe configuration for the payment mode' do
    mode = 'payment'
    run_generator [mode]

    assert_file 'config/initializers/stripe.rb', /Stripe.api_key/
    assert_migrations(mode)
    assert_model(mode)
    assert_controllers(mode)
    assert_routes
  end

  private

  def create_files
    File.open("#{PATH}/Gemfile", 'w')

    FileUtils.mkdir_p "#{PATH}/app/models"
    File.write("#{PATH}/app/models/user.rb", ':recoverable, :rememberable, :validatable')

    FileUtils.mkdir_p "#{PATH}/config"
    File.write("#{PATH}/config/routes.rb", 'devise_for :users')
  end

  def assert_migrations(mode = 'subscription')
    assert_migration 'db/migrate/add_stripe_id_to_users.rb'
    if mode == 'subscription'
      assert_migration 'db/migrate/add_premium_until_to_users.rb'
    else
      assert_migration 'db/migrate/add_premium_to_users.rb'
    end
  end

  def assert_model(mode = 'subscription')
    model_path = 'app/models/user.rb'
    assert_file model_path, /validates :stripe_id/

    return unless mode == 'subscription'

    assert_file model_path, /increment_premium/
  end

  def assert_controllers(mode = 'subscription')
    controllers_path = 'app/controllers/stripe'
    assert_file "#{controllers_path}/checkout_sessions_controller.rb", /mode:\s*'#{mode}'/

    if mode == 'subscription'
      assert_file "#{controllers_path}/webhooks_controller.rb",
                  /user\.increment_premium.*user\.update!\(premium_until:\s*nil\)/m
    else
      assert_file "#{controllers_path}/webhooks_controller.rb", /user\.update!\(premium:\s*true\)/
      assert_file "#{controllers_path}/webhooks_controller.rb", /user\.update!\(premium:\s*false\)/
    end
  end

  def assert_routes
    assert_file 'config/routes.rb', /namespace :stripe/
    assert_file 'config/routes.rb', /resources :checkout_sessions/
    assert_file 'config/routes.rb', /resource :webhook/
  end
end
