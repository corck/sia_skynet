require 'pbkdf2'
require 'tweetnacl'
require 'rbnacl'
require 'base64'
require 'bindata'

module Skynet
  class Registry
    def initialize; end

    def update
      pbkdf = PBKDF2.new(password: 'Lorem ipsum', salt: '', iterations: 1000, key_length: 32)
      bin_key = pbkdf.bin_string
      signing_key = RbNaCl::Signatures::Ed25519::SigningKey.new bin_key
      verify_key = RbNaCl::Signatures::Ed25519::VerifyKey.new bin_key

      body = post_data(signing_key, verify_key)
      post(body)
    end

    def post(body)
      res = Typhoeus::Request.new(
        'https://siasky.net/skynet/registry',
        method: :post,
        body: body.to_s
      ).run

      puts res.body
    end

    def post_data(signing_key, verify_key)
      { publickey:
        {
          algorithm: 'ed25519',
          key: verify_key.to_s
        },
        dataKey: data_key,
        revision: 0.to_s,
        signature: signing_key.sign(entry),
        data: data }
    end

    def entry
      d =
      { dataKey: data_key, data: data, revision: 0.to_s }
    end

    def encode_string(str) {
      encoded = BinData::Uint8Array.new(initial_length: (8 + str.length))
      encoded.read(str)
    }

    def data_key
      '0x' + 'vedaTest'.to_i.to_s(16)
    end

    def data
      Base64.encode64('foo')
    end
  end
end

Skynet::Registry.new.update
