class IMDB
  SEARCH_BASE_URL = "http://imdb.com/find?s=all&q="

  def self.find_movie_by_id(id)
    IMDB::Title.find_by_id(id)
  end
end
