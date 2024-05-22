# frozen_string_literal: true

require_relative "./czds/version"
require_relative "./czds/client"
require_relative "./czds/zone_file"
require_relative "./czds/cli/main"

module CZDS
  class FileSizeError < StandardError; end
  class FileAlreadyDownloadedError < StandardError; end
  class NoCredentialsError < StandardError; end
end
