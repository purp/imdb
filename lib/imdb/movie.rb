require 'imdb/title/individual'
require 'imdb/title/rated'
require 'imdb/title/timed'

class IMDB
  class Movie < IMDB::Title
    include Individual
    include Rated
    include Timed
    
    LOCAL_ATTRIBUTES = {
      :tagline => {
        :expr => "div.info[contains('Tagline:', h5)]", 
        :post => Proc.new {|n| n.inner_text.split(/\n|\s*more\s*/)[-1]},
      },
    }
    
    generate_cached_attr_readers(LOCAL_ATTRIBUTES)
    
    silence_warnings {ATTRIBUTES = LOCAL_ATTRIBUTES.merge(superclass::ATTRIBUTES)}
  end
end