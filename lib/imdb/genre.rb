class IMDB
  class Genre < IMDB::Section
    BASE_URL = "http://www.imdb.com/Sections/Genres/"
    
    def self.get_genres(node)
      return unless node && node.class == Nokogiri::XML::Element
      genres = (node/"a").map {|elem| elem.inner_text.strip} - ['more']
      genres.map {|genre| IMDB::Genre.new(genre)}
    end
  end
end