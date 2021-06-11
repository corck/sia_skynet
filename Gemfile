# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in sia_skynet.gemspec
gemspec

gem 'rake', '~> 12.0'
gem 'typhoeus', '~> 1.4.0'
gem 'mimemagic', '~> 0.4.3'
gem 'multipart_body', '~> 0.2.1'
gem 'thor', '~> 1.1.0'

group :test, :development do
  gem 'rspec', '~> 3.0'
  gem 'rubocop', '~> 1.13.0'
  gem 'rubocop-rspec', '~> 2.2.0'
  gem 'byebug', require: 'byebug'
end

group :test do
  gem "webmock", '~> 3.12.0'
  gem 'rspec-json_expectations'
end