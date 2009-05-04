require 'imdb/title/individual'
require 'imdb/title/rated'
require 'imdb/title/timed'

class IMDB
  class Movie < IMDB::Title
    include Individual
    include Rated
    include Timed
    
    silence_warnings {SINGLE_VALUE_ATTRS += [:tagline]}

    attr_reader_from_doc_with_nil_default(:tagline) do
      info_node = get_info_from_doc('Tagline:')
      info_node.inner_text.gsub(/^\s*Tagline:\s+|\s*more\s*$/,'').strip
    end
  end
end