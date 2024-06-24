require 'rp_scripts/configuration'
require 'rp_scripts/session'
require 'rp_scripts/version'

module RpScripts
  def self.config
    @@config
  end

  def self.configure
    @@config = Configuration.new
    yield @@config
  end
end
