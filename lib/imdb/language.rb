class IMDB
  class Language < IMDB::Section
    def self.get_languages(node)
      return unless node && node.class == Nokogiri::XML::Element
      languages = (node/"a").map {|elem| elem.inner_text.strip} - ['more']
      languages.map {|language| IMDB::Language.new(language)}
    end
    
    BASE_URL = "http://www.imdb.com/Sections/Languages/"
  end
end