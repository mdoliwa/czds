require 'thor'
require 'json'

module CZDS
  module CLI
    class Main < Thor
      attr_reader :tld

      desc "download", "Download zone file"
      option :config_file, type: :string, default: './czds.config.json', desc: 'Path to config file'
      option :tld, type: :string, desc: 'Top-level domain, default: com'
      option :download_dir, type: :string, desc: 'Directory to download zone file, default: ./'
      option :no_timestamp, type: :boolean, desc: 'Disable timestamp in file name'
      option :username, type: :string, desc: 'CZDS username'
      option :password, type: :string, desc: 'CZDS password'

      def download
        config_file = load_config(options[:config_file])
        configure_client(options, config_file)

        tld = options[:tld] || config_file['tld'] || CZDS::Configuration::DEFAULTS[:tld]

        zone_file = CZDS::ZoneFile.new(tld)
        zone_file.download
      end

      private

      def configure_client(options, config_file)
        CZDS::Client.configure do |config|
          config.username = options[:username] || config_file['username']
          config.password = options[:password] || config_file['password']
          config.download_dir = options[:download_dir] || config_file['download_dir'] || CZDS::Configuration::DEFAULTS[:download_dir]
          config.timestamp_file_name = ![options[:no_timestamp], config_file['no_timestamp']].compact[0]
        end
      end

      def load_config(config_file)
        return {} unless File.exist?(config_file)

        JSON.parse(File.read(config_file))
      end
    end
  end
end

