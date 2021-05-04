# frozen_string_literal: true

require 'json'
require 'typhoeus'

module Skynet
  # Client for interacting with Skynet
  #
  # Default portal is set to https://siasky.net
  #
  class Client
    DEFAULT_SKYNET_PORTAL_URL = 'https://siasky.net'
    DEFAULT_SKYNET_PORTAL_PATH = '/skynet/skyfile'
    URI_SKYNET_PREFIX = 'sia://'
    DEFAULT_USER_AGENT = 'Sia-Agent'

    attr_reader :user_agent
    attr_accessor :config

    # Initializes the client, allows to set a custom portal or uses siasky.net as default
    #
    # @param [Hash] config the configuration options to initialize the client with
    # @option config [String] :api_key The API password used for authentication.
    # @option config [String] :user_agent Allows changing the User Agent, as some portals may reject user agents
    #  that are not `Sia-Agent` for security reasons.
    # @option config [String] :on_upload_progress Optional callback to track upload progress. (Not implemented yet)
    # @option config [String] :portal url to a custom portal, defaults to https://siasky.net
    # @option config [String] :dirname Optional directory name on skynet
    # @option config [Boolean] :verbose Set to true to log network requests

    def initialize(custom_config = {})
      @config = default_upload_options
      @config.merge!(custom_config)
      @api_key = config[:api_key] || nil
      Typhoeus::Config.user_agent = config[:user_agent]
      @on_upload_progress = config[:on_upload_progress]
      Typhoeus::Config.verbose = true # if custom_config[:verbose]
    end

    # Takes a file path and uploads it
    #
    # @param [String] file File or file path where the file is located
    #
    # @param [Hash] custom_opts additional upload options
    # @option custom_opts [String] :portal_file_field_name The field name for files on the portal.
    #   Usually should not need to be changed.
    # @option custom_opts [String] :portal_directory_file_field_name The field name for directories on the portal.
    #   Usually should not need to be changed.
    # @option custom_opts [String] :filename Custom filename.
    #   This is the filename that will be returned when downloading the file in a browser
    # @option custom_opts [String] :custom_dirname Custom dirname. If this is empty,
    #   the base name of the directory being uploaded will be used by default.
    # @option custom_opts [String] :timeout_seconds Custom filename. The timeout in seconds.
    # @option custom_opts [Boolean] :full_response Returns full hash with skylink, merkleroot and bitfield
    #
    # @return [String] Returns the sialink (sia://AABBCC) by default
    # @return [Hash] response Hash with full response from skynet including skylink, merkleroot
    #  bitfield and sialink if :full_response option is given
    #  @option response [String] :skylink
    #
    # @example Default response:
    #  sia://KAA54bKo-YqFRj345xGXdo9h15k.....
    #
    # @example Full response as hash
    #   {
    #     "skylink"=>"KAA54bKo-YqFRjDxRxGXdo9h15k8......",
    #     "merkleroot"=>"39e1b2a....",
    #     "bitfield"=>40,
    #     "sialink"=>"sia://KAA54bKo-YqFRjDxRxGXdo9h15k8...."
    #   }
    #
    #
    def upload_file(file, custom_opts = {})
      res = upload(file, custom_opts)
      json = JSON.parse res.body
      sialink = "#{URI_SKYNET_PREFIX}#{json['skylink']}"

      custom_opts[:full_response] == true ? json.merge({ 'sialink' => sialink }) : sialink
    end

    # Upload a directory
    #
    def upload_directory(path)
      files = files_to_upload(path)
      hydra = Typhoeus::Hydra.new
      files.collect { |f| hydra.queue upload(f) }
      hydra.run
    end

    # Download a file
    # @param [String] path The local path where the file should be downloaded to.
    # @param [String] skylink The skylink that should be downloaded. The skylink can contain an optional path.
    #
    # @return [String] path Path of the downloaded file
    def download_file(path, skylink)
      f = File.open(path, 'wb')
      begin
        request = Typhoeus::Request.new("#{portal}/#{skylink}", headers: default_headers)
        request.on_headers do |response|
          raise 'Request failed' if response.code != 200
        end
        request.on_body do |chunk|
          f.write(chunk)
        end
        request.on_complete do |_response|
          f.close
        end
        request.run
      ensure
        f.close
      end

      path
    end

    # Downloads the metadata of a skylink
    #
    # @param [String] skylink Skylink of the file
    #
    # @return [Hash]
    #
    # @example Response
    #   {
    #     'filename' => 'foo.pdf',
    #     'length' => 21_977,
    #     'subfiles' =>
    #     { 'foo.pdf' =>
    #       { 'filename' => 'foo.pdf',
    #         'contenttype' => 'application/octet-stream',
    #         'len' => 21_977 } }
    #   }
    def get_metadata(skylink)
      res = Typhoeus::Request.head(
        "#{portal}/#{skylink}", headers: default_headers
      )
      JSON.parse res.headers['skynet-file-metadata']
    end

    private

    # Return all files recursively, exclude directories
    #
    def files_to_upload(path)
      Dir.glob("#{path}/**/*")
         .reject { |fn| File.directory?(fn) }
         .map do |f|
        relative_path = f.gsub(%r{#{path}/}, '')
        { path: f, file_name: "#{config[:portal_directory_file_fieldname]}=@.#{relative_path}" }
      end
    end

    # Returns default upload options
    def default_upload_options
      opts = {}
      opts[:portal] = DEFAULT_SKYNET_PORTAL_URL
      opts[:portal_path] = DEFAULT_SKYNET_PORTAL_PATH
      opts[:user_agent] = DEFAULT_USER_AGENT
      opts[:portal_file_fieldname] = 'file'
      opts[:portal_directory_file_fieldname] = 'files[]'
      opts[:filename] = ''
      opts[:dirname] = ''
      opts
    end

    def portal_path
      File.join(config[:portal_path], config[:dirname])
    end

    def portal
      config[:portal]
    end

    def upload(file, opts)
      params = opts.filter { |k| default_upload_options.keys.include?(k) }

      Typhoeus.post(
        "#{portal}#{portal_path}",
        params: params,
        body: {
          file: File.open(file, 'r')
        }
      )
    end
  end
end
