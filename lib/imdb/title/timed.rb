class IMDB
  class Title
    module Timed      
      LOCAL_ATTRIBUTES = {
        :runtime => {:expr => "div.info[contains('Runtime:', h5)]", :post => Proc.new {|n| n.inner_text.split(/\s*\n\s*/)[-1]}},
      }
      
      generate_cached_attr_readers(LOCAL_ATTRIBUTES)
      
      def self.included(host_class)
        silence_warnings {host_class.const_set("ATTRIBUTES", host_class.const_get("ATTRIBUTES").merge(LOCAL_ATTRIBUTES))}
      end
    end
  end
end
