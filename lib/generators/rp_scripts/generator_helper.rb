module RpScripts
  module GeneratorHelper
    def migration_version
      "[#{ActiveRecord::Migration.current_version}]"
    end
  end
end
