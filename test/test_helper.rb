# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end


HOST_ROOT = File.expand_path("../../dummy", File.dirname(__FILE__))

require "generators/react_particles/install_generator"


###################################################
###################################################
#########       DEVISE TEST HELPERS       #########
###################################################
###################################################
# ENV["RAILS_ENV"] = "test"
# DEVISE_ORM = (ENV["DEVISE_ORM"] || :active_record).to_sym
#
# $:.unshift File.dirname(__FILE__)
# puts "\n==> Devise.orm = #{DEVISE_ORM.inspect}"
#
# require "rails_app/config/environment"
# require "rails/test_help"
# require "orm/#{DEVISE_ORM}"
#
# I18n.load_path << File.expand_path("../support/locale/en.yml", __FILE__)
#
# require 'mocha/minitest'
# require 'timecop'
# require 'webrat'
# Webrat.configure do |config|
#   config.mode = :rails
#   config.open_error_files = false
# end
#
# if ActiveSupport.respond_to?(:test_order)
#   ActiveSupport.test_order = :random
# end
#
# OmniAuth.config.logger = Logger.new('/dev/null')
#
# # Add support to load paths so we can overwrite broken webrat setup
# $:.unshift File.expand_path('../support', __FILE__)
# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
#
# # For generators
# require "rails/generators/test_case"
# require "generators/devise/install_generator"
# require "generators/devise/views_generator"
# require "generators/devise/controllers_generator"
