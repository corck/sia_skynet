require 'pbkdf2'
require 'tweetnacl'
require 'rbnacl'

pbkdf = PBKDF2.new(:password=>"Lorem ipsum", :salt=>"", :iterations=>1000, key_length: 32 )

puts pbkdf.hex_string
bin_key = pbkdf.bin_string

signing_key = RbNaCl::Signatures::Ed25519::SigningKey.new bin_key
