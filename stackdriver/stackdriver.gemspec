# -*- encoding: utf-8 -*-
require File.expand_path("../lib/stackdriver/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "stackdriver"
  gem.version       = Stackdriver::VERSION

  gem.authors       = ["Heng Xiong"]
  gem.email         = ["hxiong388@gmail.com"]
  gem.description   = "stackdriver is the official library for Google Stackdriver APIs."
  gem.summary       = "API Client library for Google Stackdriver"
  gem.homepage      = "http://googlecloudplatform.github.io/google-cloud-ruby/#/docs/stackdriver"
  gem.license       = "Apache-2.0"

  gem.files         = `git ls-files -- lib/*`.split("\n") +
                      ["README.md", "LICENSE", ".yardopts"]
  gem.require_paths = ["lib"]

  gem.required_ruby_version = ">= 2.0.0"

  gem.add_runtime_dependency "google-cloud-error_reporting"
  gem.add_runtime_dependency "google-cloud-logging"
  gem.add_runtime_dependency "google-cloud-monitoring"

  gem.add_development_dependency "minitest", "~> 5.9"
  gem.add_development_dependency "minitest-autotest", "~> 1.0"
  gem.add_development_dependency "minitest-focus", "~> 1.1"
  gem.add_development_dependency "minitest-rg", "~> 5.2"
  gem.add_development_dependency "autotest-suffix", "~> 1.1"
  gem.add_development_dependency "rubocop", "~> 0.43"
  gem.add_development_dependency "simplecov", "~> 0.9"
  gem.add_development_dependency "yard", "~> 0.9"
  gem.add_development_dependency "railties", "~> 4.0"
end
