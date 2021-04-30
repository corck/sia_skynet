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

  config.before do
    # upload stub
    stub_request(:post, /siasky.net/)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => Skynet::Client::DEFAULT_USER_AGENT
        }
      )
      .to_return(status: 200, body: '{"skylink":"KAA54bKo-YqFRj345xGXdo9h15k84K8zl7ykrKw8kQyksQ",
        "merkleroot":"39e1b2a8f98a854630f1471345768f61d7993ce0af3397bca4acac3c910ca4b1",
        "bitfield":40}')

    # download stub
    stub_request(:get, 'https://siasky.net/KAA54bKo-YqFRjDxRxGXdo9h15k84K8zl7ykrKw8kQyksQ')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => Skynet::Client::DEFAULT_USER_AGENT
        }
      )
      .to_return(status: 200, body: 'foo-bar', headers: {})

    stub_request(:head, 'https://siasky.net/KAA54bKo-YqFRjDxRxGXdo9h15k84K8zl7ykrKw8kQyksQ')
      .with(
        headers: {
          'User-Agent' => 'Sia-Agent'
        }
      )
      .to_return(status: 200, body: nil, headers: {
                   "skynet-file-metadata": '{"filename":"foo.pdf","length":21977,"subfiles":{"kathrin-knight-rider.pdf":{"filename":"kathrin-knight-rider.pdf","contenttype":"application/octet-stream","len":21977}}}'
                 })
  end
end
