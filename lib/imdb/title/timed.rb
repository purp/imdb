class IMDB
  class Title
    module Timed      
      attr_reader_from_doc_with_nil_default(:runtime) do
        info = get_info_from_doc('Runtime:')
        info.inner_text.gsub(/^\s*Runtime:\s+|\s*more\s*$/,'') if info
      end

      def self.included(host_class)
        silence_warnings {host_class.const_set("SINGLE_VALUE_ATTRS", host_class.const_get("SINGLE_VALUE_ATTRS") + [:runtime])}
      end
    end
  end
end
