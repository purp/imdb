class IMDB
  class Title
    module Rated
      LOCAL_ATTRIBUTES = {
        :release_date => {:expr => "div.info[contains('Release Date:', h5)]", :post => Proc.new {|n| Date.parse(n.inner_text.split(/\n|\s*more\s*/)[-1])}},
      }
      
      generate_cached_attr_readers(LOCAL_ATTRIBUTES)
      
      def self.included(host_class)
        silence_warnings {host_class.const_set("ATTRIBUTES", host_class.const_get("ATTRIBUTES").merge(LOCAL_ATTRIBUTES))}
      end
    end
  end
end
