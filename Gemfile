# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in sia_skynet.gemspec
gemspec

gem 'rake', '~> 12.0'
gem 'typhoeus', '~> 1.4.0'
gem 'mimemagic', '~> 0.4.3'
gem 'multipart_body'

group :test, :development do
  gem 'rspec', '~> 3.0'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'byebug', require: 'byebug'
end

group :test do
  gem "webmock"
  gem 'rspec-json_expectations'
end