# frozen_string_literal: true

require 'forwardable'
require_relative "./client"

module CZDS
  class ZoneFile
    extend Forwardable

    attr_reader :tld, :client

    def_delegators :status, :file_name, :length, :updated_at, :timestamp

    def initialize(tld = "com")
      @tld = tld
      @client = Client.new 
    end

    def download
      client.download_zone_file(tld)
    end

    def status
      @status ||= client.zone_file_status(tld)
    end
  end
end
