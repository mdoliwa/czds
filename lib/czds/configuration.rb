# frozen_string_literal: true

module CZDS
  class Configuration
    DEFAULTS = {
      user_agent: "czds/#{CZDS::VERSION} (Ruby Client)",
      tld: "com",
      download_dir: "./"
    }

    attr_accessor :username, :password, :download_dir, :timestamp_file_name, :user_agent

    def initialize
      @download_dir = DEFAULTS[:download_dir]
      @timestamp_file_name = true
      @user_agent = DEFAULTS[:user_agent]
    end
  end
end
