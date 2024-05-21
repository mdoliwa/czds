# frozen_string_literal: true

module CZDS
  class Configuration
    attr_accessor :username, :password, :download_dir, :timestamp_file_name, :user_agent

    def initialize
      @download_dir = "./"
      @timestamp_file_name = true
      @user_agent = "czds/#{CZDS::VERSION} (Ruby Client)"
    end
  end
end
