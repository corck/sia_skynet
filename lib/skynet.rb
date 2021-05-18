# frozen_string_literal: true

require 'skynet/version'
require 'skynet/client'

module Skynet
  class Error < StandardError; end

  class NoMetadataError < Skynet::Error; end
end
