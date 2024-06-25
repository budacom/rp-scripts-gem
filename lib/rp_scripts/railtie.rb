module RpScripts
  class Railtie < Rails::Railtie
    rake_tasks do
      namespace :rp do
        desc "Run watcher"
        task watch: :environment do
          watcher = RpScripts::Watcher.new

          trap('INT') { watcher.stop_watching }
          trap('TERM') { watcher.stop_watching }

          watcher.watch
        end
      end
    end

    initializer "initialize rp scripts" do
      require 'rp_scripts/activeadmin' if defined? ActiveAdmin
    end
  end
end
