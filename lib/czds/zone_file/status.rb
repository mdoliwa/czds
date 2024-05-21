module CZDS
  class ZoneFile
    Status = Data.define(:file_name, :length, :updated_at) do
      def timestamp
        updated_at.gsub(':', '-')  
      end
    end
  end
end
