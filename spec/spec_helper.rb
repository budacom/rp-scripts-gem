require 'action_controller'
require 'active_support/all'
require 'active_record'
require 'database_cleaner/active_record'
require 'factory_bot'
require 'pry'
require 'shoulda/matchers'
require './lib/generators/rp_scripts/generator_helper'

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }
Dir["./spec/factories/**/*.rb"].sort.each { |f| require f }

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ":memory:"
)

# ActiveRecord::Base.logger = Logger.new($stdout)
ActiveRecord::Migration.verbose = false

migration_template = File.open("lib/generators/rp_scripts/templates/migration.rb")

# need to eval the template with the migration_version intact
migration_context = Class.new do
  include RpScripts::GeneratorHelper

  def my_binding
    binding
  end
end

migration_ruby = ERB.new(migration_template.read).result(migration_context.new.my_binding)
eval(migration_ruby) # rubocop:disable Security/Eval

ActiveRecord::Schema.define { CreateRpScriptsSessions.migrate(:up) }

# Purely useful for test cases...
# class Story < ActiveRecord::Base
#   if ::ActiveRecord::VERSION::MAJOR < 4 && ActiveRecord::VERSION::MINOR < 2
#     set_primary_key :story_id
#   else
#     self.primary_key = :story_id
#   end
#   def tell
#     text
#   end

#   def whatever(number)
#     tell * number
#   end
#   default_scope { where(scoped: true) }

#   handle_asynchronously :whatever
# end

# Add this directory so the ActiveSupport autoloading works
# ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

require 'rp-scripts'
