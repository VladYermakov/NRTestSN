ENV['RAILS_ENV'] ||= 'test'

if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter '/app/channels/'
    add_filter '/app/jobs/'
    add_filter '/app/mailers/'
  end
  puts "required simplecov"
end

require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'rspec/its'

require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/webkit'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :webkit
Capybara.default_max_wait_time = 10
#Capybara.ignore_hidden_elements = false

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include Warden::Test::Helpers
  config.include Capybara::Angular::DSL

  config.after :each do
    Warden.test_reset!
  end
end
