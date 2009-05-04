# If you refactor anything that breaks the old_skool_spec, fix it here.
class Imdb < IMDB
  IMDB_MOVIE_BASE_URL   = IMDB::Movie::BASE_URL
  IMDB_NAME_BASE_URL    = IMDB::Name::BASE_URL   
  IMDB_COMPANY_BASE_URL = IMDB::Company::BASE_URL
  IMDB_GENRE_BASE_URL   = IMDB::Genre::BASE_URL  
  IMDB_SEARCH_BASE_URL  = IMDB::SEARCH_BASE_URL 
end

class IMDB::Title
  alias :imdb_id :id
  
  alias :writers_without_manual_check :writers
  def writers
    @writers_was_manually_set ? (@writers || []) : writers_without_manual_check
  end
  
  alias :directors_without_manual_check :directors
  def directors
    @directors_was_manually_set ? (@directors || []) : directors_without_manual_check
  end
  
  alias :genres_without_manual_check :genres
  def genres
    @genres_was_manually_set ? (@genres || []) : genres_without_manual_check
  end
  
  def writers=(value)
    @writers_was_manually_set = true
    @writers = value
  end

  def directors=(value)
    @directors_was_manually_set = true
    @directors = value
  end

  def genres=(value)
    @genres_was_manually_set = true
    @genres = value
  end
end

class IMDB::Company
  alias :imdb_id :id
end

class IMDB::Genre
  alias :imdb_id :id
end

class IMDB::Name
  alias :imdb_id :id
end

class ImbdCompany < IMDB::Company
end

class ImdbGenre < IMDB::Genre
end

class ImdbMovie < IMDB::Movie
end

class ImdbName < IMDB::Name
end

