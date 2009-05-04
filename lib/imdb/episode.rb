require 'imdb/title/episodic'
require 'imdb/title/individual'
require 'imdb/title/timed'

class IMDB
  class Episode < IMDB::Title
    include Episodic
    include Individual
    include Timed
  end
end