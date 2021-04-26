# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'net/http/post/multipart'
require 'json'

module Skynet
  # Client for interacting with Skynet
  #
  # Default portal is set to https://siasky.net
  #
  class Client
    DEFAULT_SKYNET_PORTAL_URL = 'https://siasky.net'
    URI_SKYNET_PREFIX = 'sia://'

    attr_reader :user_agent, :portal
    attr_accessor :config

    # Initializes the client, allows to set a custom portal or uses siasky.net as default
    #
    # @param [Hash] config the configuration options to initialize the client with
    # @option config [String] :api_key The API password used for authentication.
    # @option config [String] :custom_user_agent Allows changing the User Agent, as some portals may reject user agents
    #  that are not `Sia-Agent` for security reasons.
    # @option config [String] :on_upload_progress Optional callback to track upload progress. (Not implemented yet)
    # @option config [String] :custom_portal url to a custom portal, defaults to https://siasky.net
    #

    def initialize(custom_config = {})
      @config = default_upload_options
      @config.merge!(custom_config)
      @portal = config[:custom_portal] || DEFAULT_SKYNET_PORTAL_URL
      @api_key = config[:api_key] || nil
      @user_agent = config[:custom_user_agent] || 'Sia-Agent'
      @on_upload_progress = config[:on_upload_progress]
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
    # @option custom_opts [String] :custom_filename Custom filename.
    #   This is the filename that will be returned when downloading the file in a browser
    # @option custom_opts [String] :custom_dirname Custom dirname. If this is empty,
    #   the base name of the directory being uploaded will be used by default.
    # @option custom_opts [String] :timeout_seconds Custom filename. The timeout in seconds.
    # @option custom_opts [Boolean] :full_response Returns full hash with skylink, merkleroot and bitfield
    #
    # @return [String] Returns the sialink (sia://AABBCC) by default
    # @return [Hash] Hash with full response from skynet including skylink, merkleroot
    #  bitfield and sialink if :full_response option is given
    #
    # @example Returns sialink:
    #  sia://KAA54bKo-YqFRj345xGXdo9h15k84K8zl7ykrKw8kQyksQ
    #
    # @example Full response as hash
    #
    #
    # rubocop:disable Metrics/AbcSize
    def upload_file(file, custom_opts = {})
      uri = URI.parse(portal)
      url = URI::HTTPS.build(host: uri.host, path: portal_path)

      req = Net::HTTP::Post::Multipart.new url.path, 'file' => file_io(file, config)
      req['User-Agent'] = user_agent
      res = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
        http.request(req)
      end

      json = JSON.parse res.body
      sialink = "#{URI_SKYNET_PREFIX}#{json['skylink']}"
      custom_opts[:full_response] == true ? json.merge({ 'sialink' => sialink }) : sialink
    end

    private

    def file_io(file, opts)
      UploadIO.new(file, 'application/octet-stream', opts['custom_filename'])
    end

    # Returns default upload options
    def default_upload_options
      opts = {}
      opts[:portal_path] = '/skynet/skyfile'
      opts[:portal_file_fieldname] = 'file'
      opts[:portal_directory_file_fieldname] = 'files[]'
      opts[:custom_filename] = ''
      opts[:custom_dirname] = ''

      opts
    end

    def portal_path
      base_path = '/skynet/skyfile/'
      dir = config[:custom_dirname]
      File.join(base_path, dir)
    end
  end
end
