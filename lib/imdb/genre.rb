class IMDB
  class Genre
    attr_accessor :id, :name
  
    def initialize(imdb_id)
      self.id = imdb_id;
      self.name = imdb_id;
    end
  end
end