class IMDB
  class Title
    module Rated      
      attr_reader_from_doc_with_nil_default(:release_date) do
        info = get_info_from_doc('Release Date:').inner_text
        Date.parse(info.gsub(/^\s*Release Date:\s+|\s*more\s*$/,''))
      end

      def self.included(host_class)
        silence_warnings {host_class.const_set("SINGLE_VALUE_ATTRS", host_class.const_get("SINGLE_VALUE_ATTRS") + [:release_date])}
      end
    end
  end
end
