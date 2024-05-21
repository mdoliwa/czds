# frozen_string_literal: true

require_relative "lib/czds/version"

Gem::Specification.new do |spec|
  spec.name = "czds"
  spec.version = CZDS::VERSION
  spec.authors = ["Marcin Doliwa"]
  spec.email = ["mdoliwa@gmail.com"]

  spec.summary = "Ruby client for the ICANN Centralized Zone Data Service (CZDS) API. "
  spec.homepage = "https://github.com/mdoliwa/czds"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.add_dependency "faraday", "~> 2.0"
end
