# If you refactor anything that breaks the old_skool_spec, fix it here.
class Imdb < IMDB
  IMDB_MOVIE_BASE_URL   = IMDB::MOVIE_BASE_URL
  IMDB_NAME_BASE_URL    = IMDB::NAME_BASE_URL   
  IMDB_COMPANY_BASE_URL = IMDB::COMPANY_BASE_URL
  IMDB_GENRE_BASE_URL   = IMDB::GENRE_BASE_URL  
  IMDB_SEARCH_BASE_URL  = IMDB::SEARCH_BASE_URL 
end

class IMDB::Title
  alias :imdb_id :id
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

