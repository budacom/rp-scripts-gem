require 'rp_scripts/configuration'
require 'rp_scripts/executor'
require 'rp_scripts/session'
require 'rp_scripts/version'
require 'rp_scripts/watcher'
require 'rp_scripts/railtie' if defined? Rails::Railtie

module RpScripts
  def self.config
    @@config
  end

  def self.configure
    @@config = Configuration.new
    yield @@config
  end
end
