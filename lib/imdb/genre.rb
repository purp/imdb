class IMDB
  class Genre
    def self.get_genres(node)
      return unless node && node.class == Nokogiri::XML::Element
      genres = (node/"a").map {|elem| elem.inner_text} - ['more']
      genres.map {|genre| IMDB::Genre.new(genre)}
    end
    
    attr_accessor :id, :name
  
    def initialize(imdb_id)
      self.id = imdb_id;
      self.name = imdb_id;
    end
  end
end