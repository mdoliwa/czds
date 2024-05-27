module CZDS
  class ZoneFile
    Status = Data.define(:file_name, :length, :updated_at) do
      def timestamp
        updated_at.gsub(':', '-')  
      end

      def to_h
        {
          file_name:,
          length:,
          updated_at:,
          timestamp:,
        }
      end
    end
  end
end
