# -*- encoding: utf-8 -*-
require File.expand_path("../lib/active_braintree/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "active_braintree"
  s.version     = ActiveBraintree::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mike Enriquez"]
  s.email       = ["mike@edgecase.com"]
  s.summary     = "ActiveRecord-like classes for working with Braintree"
  s.description = "ActiveBraintree provides objects that can be used with Rails' form_for, error_messages_for, error_messages_on, etc..."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "activerecord", '>= 2.3.8'
  s.add_development_dependency "bundler", ">= 1.0.0.rc.6"
  s.add_development_dependency "rspec", ">=2.0.0.beta.20"
  s.add_development_dependency "ruby-debug"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  s.require_path = 'lib'
end

