# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rp_scripts/version'

Gem::Specification.new do |spec|
  spec.name          = "rp-scripts"
  spec.version       = RpScripts::VERSION
  spec.summary       = "Developer Scripts Runner"
  spec.authors       = ["devs@buda.com"]

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "actionpack", [">= 5.0", "< 8.0"]
  spec.add_dependency "activerecord", [">= 5.0", "< 8.0"]
  spec.add_dependency "activesupport", [">= 5.0", "< 8.0"]
  spec.add_dependency "sentry-ruby", "~> 5.7.0"
  spec.add_development_dependency "bundler", "~> 2.3.26"
  spec.add_development_dependency "database_cleaner-active_record"
  spec.add_development_dependency "factory_bot_rails", "~> 6.2"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec-rails", "~> 6.0"
  spec.add_development_dependency "shoulda-matchers", "~> 4.5.1"
  spec.add_development_dependency "sqlite3"
end
