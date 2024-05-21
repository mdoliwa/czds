# frozen_string_literal: true

require_relative "./czds/version"
require_relative "./czds/client"
require_relative "./czds/zone_file"

module CZDS
  class FileSizeError < StandardError; end
  class FileAlreadyDownloadedError < StandardError; end
end
