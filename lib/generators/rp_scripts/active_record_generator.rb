# frozen_string_literal: true

require 'generators/rp_scripts/generator_helper'
require 'rails/generators/migration'
require 'rails/generators/active_record'

# Extend the DelayedJobGenerator so that it creates an AR migration
module RpScripts
  class ActiveRecordGenerator < ::Rails::Generators::Base
    include ::ActiveRecord::Generators::Migration
    include ::RpScripts::GeneratorHelper

    source_paths << File.join(File.dirname(__FILE__), 'templates')

    def create_migration_file
      migration_template(
        'migration.rb',
        'db/migrate/create_rp_scripts_sessions.rb'
      )
    end
  end
end
