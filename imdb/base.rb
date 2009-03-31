class IMDB

  MOVIE_BASE_URL = "http://www.imdb.com/title/"
  NAME_BASE_URL = "http://www.imdb.com/name/"
  COMPANY_BASE_URL = "http://www.imdb.com/company/"
  GENRE_BASE_URL = "http://www.imdb.com/Sections/Genres/"
  SEARCH_BASE_URL = "http://imdb.com/find?s=all&q="

  def self.find_movie_by_id(id)
    IMDB::Movie.find_by_id(id)
  end
end
