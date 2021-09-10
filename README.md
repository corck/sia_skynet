# Skynet

Ruby gem for interacting with [Skynet](https://siasky.net/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'skynet_ruby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install skynet_ruby

## Usage

    require 'skynet'

### Uploading to a Skynet portal

#### Uploading a single file

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

#### Uploading a directory:

    client.upload_directory '/path/to/directory'

#### Downloading a file or directory:

This function downloads a skylink using HTTP streaming. The call blocks until the data is received. There is a 30s default timeout applied to downloading a skylink. If the data can not be found within this 30s time constraint, a 404 error will be returned. This timeout is configurable.

A directory will be downloaded as zip file, otherwise as regular file.

    client.download_file("/path/foo.zip", skylink)

#### Getting Metadata

Returns the metadata of an upload. Currently quite often no metadata is returned and a `Skynet::NoMetadataError` exception will be raised.

    client.get_metadata "ZAAZyxRQ7ImB_...."

#### Persisting Files (Upload to an account)

Files are by default persisted for 90 days if you upload to skynet. If you have an account files can be pinned endlessly. You can read more [here](https://docs.siasky.net/developer-guides/server-hosted-skynet-usage#file-persistence).

To upload an account you need to get a JWT token. You can copy that one from the developer consoles, look for the `skynet-jwt` cookie and copy the value. See [docs](https://docs.siasky.net/developer-guides/server-hosted-skynet-usage#file-persistence).

! JWTs expire after 720 hours and there's no tooling to detect if your JWT is expired.

    Skynet::Client.new(jwt: "XYZ...)

## Progress

☑ Uploading a file\
☑ Uploading a directory\
☑ Downloading a file\
☑ Downloading a directory\
☑ Getting Metadata\
☑ Uploading Files to an account\
☐ SkyDB\
☐ Registry\
☐ MySky



## Contributing


Bug reports and pull requests are welcome on GitHub at https://github.com/corck/sia_skynet.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

Copyright 2021, by Christoph Klocker.