# Skynet

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/sia_skynet`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sia_skynet'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sia_skynet

## Usage

    require 'skynet'

### Uploading to a Skynet portal

Uploading a single file:

    client = Skynet::Client.new
    client.upload_file '/path/to/file.pdf'
    => "sia://ZAAZyxRQ7Ixzd3zujn1ly8RA..."

    # if you want to get the full response
    client.upload_file '/path/to/file.pdf', full_response: true
    => {
         "skylink"=>"ZAAZyxRQ7Ixzd3zujn1ly8RA...",
         "merkleroot"=>"19cb1450ec8981fcc63c73777cee8e7d65cbc44",
         "bitfield"=>100,
         "sialink"=>"sia://ZAAZyxRQ7Ixzd3zujn1ly8RA"
       }

Uploading a directory:

    TODO

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/corck/sia_skynet.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

Copyright, 2021, by Christoph Klocker.