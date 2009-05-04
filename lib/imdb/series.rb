require 'imdb/title/episodic'
require 'imdb/title/rated'
require 'imdb/title/timed'

class IMDB
  class Series < IMDB::Title
    include Episodic
    include Rated
    include Timed
  end
end