class IMDB
  class Company
    attr_accessor :id, :name
  
    def initialize(imdb_id, name)
      self.id = imdb_id;
      self.name = name;
    end
  end
end