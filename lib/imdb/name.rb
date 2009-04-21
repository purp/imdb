class IMDB
  class Name
    attr_accessor :id, :name, :role
  
    def initialize(imdb_id, name, role = '')
      self.id = imdb_id;
      self.name = name;
      self.role = role;
    end
  end
end