# frozen_string_literal: true

require 'bundler/setup'
require 'skynet'
require 'webmock/rspec'
require 'rspec/json_expectations'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    # upload stub
    stub_request(:post, /siasky.net/)
      .to_return(status: 200, body: '{"skylink":"KAA54bKo-YqFRj345xGXdo9h15k84K8zl7ykrKw8kQyksQ",
        "merkleroot":"39e1b2a8f98a854630f1471345768f61d7993ce0af3397bca4acac3c910ca4b1",
        "bitfield":40}')
  end
end
