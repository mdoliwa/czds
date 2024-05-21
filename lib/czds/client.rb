# frozen_string_literal: true

require 'faraday'
require 'forwardable'
require_relative './configuration'
require_relative './zone_file/status'

module CZDS
  class Client
    extend Forwardable

    @config = Configuration.new

    class << self
      attr_accessor :config

      def configure
        yield(config) if block_given?
      end
    end

    attr_reader :zone_file_statuses

    def_delegators :@config, :username, :password, :download_dir, :timestamp_file_name, :user_agent

    def initialize
      @config = self.class.config
      @zone_file_statuses = {}
    end

    def connection(url)
      Faraday.new(
        url:,
        headers: {
          'Authorization' => "Bearer #{access_token}",
          'User-Agent' => user_agent,
        })
    end

    def zone_file_status(tld)
      return zone_file_statuses[tld] unless zone_file_statuses[tld].nil?

      conn = connection(download_link(tld))

      response = conn.head

      headers = response.headers.slice('content-disposition', 'content-length', 'last-modified')
      headers['content-length'] = headers['content-length'].to_i
      headers['last-modified'] = DateTime.parse(headers['last-modified']).strftime('%Y-%m-%dT%H:%M:%S')
      headers['content-disposition'] = headers['content-disposition'].match(/filename=(.*)$/)[1]

      @zone_file_statuses[tld] = CZDS::ZoneFile::Status.new(*headers.values)
    end

    def download_links
      return @download_links unless @download_links.nil?

      conn = connection('https://czds-api.icann.org')

      response = conn.get("/czds/downloads/links")

      download_links = JSON.parse(response.body)
    end

    def download_link(tld)
      download_links.find { |link| link =~ /#{tld}\.zone$/ }
    end

    def download_zone_file(tld)
      status = zone_file_status(tld)

      file_name = timestamp_file_name ? "#{status.timestamp}_#{status.file_name}" : status.file_name
      file_path = File.join(download_dir, file_name)

      raise FileAlreadyDownloadedError if File.exist?(file_path) && File.size(file_path) == status.length

      conn = connection(download_link(tld)) 

      File.open(file_path, 'wb') do |file|
        response = conn.get do |req|
          req.options.on_data = Proc.new { |chunk| file.write(chunk) }
        end
      end

      raise FileSizeError if File.size(file_path) != status.length

      status.length
    end

    private

    def access_token
      return @access_token unless @access_token.nil?

      conn = Faraday.new(
        url: 'https://account-api.icann.org',
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'User-Agent' => user_agent,
        }
      )

      response = conn.post("/api/authenticate") do |req|
        req.body = { username:, password: }.to_json
      end

      @access_token = JSON.parse(response.body)['accessToken'] if response.status == 200
    end
  end
end
