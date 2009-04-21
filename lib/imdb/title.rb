class IMDB
  class Title < IMDB
    BASE_URL = "http://www.imdb.com/title/"

    def self.find_by_id(id)
      data = open(BASE_URL + id).readlines
      if data.grep(/tv-extra/).size > 0
        IMDB::Series.new(data)
      elsif data.grep(/epnav/).size > 0
        IMDB::Episode.new(data)
      elsif data.grep(/Tagline:/).size > 0
        IMDB::Movie.new(data)
      else
        IMDB::Title.new(data)
      end
    end
    
    attr_reader_from_doc_with_nil_default(:id) do
      File.basename((@doc%"link[@rel='canonical']").attributes['href'])
    end
    
    attr_reader_from_doc_with_nil_default(:title) do
      @doc.at("meta[@name='title']")['content'].gsub(/\(\d{4}\)/,'').strip
    end
    
    attr_reader_from_doc_with_nil_default(:rating) do
      rating_text = (@doc/"div.rating/div.meta/b").inner_text
      if rating_text =~ /([\d\.]+)\/10/
        @rating = $1
      end
    end
    
    attr_reader_from_doc_with_nil_default(:poster_url) do
      @doc.at("div.photo/a[@name='poster']/img")['src']
    end
    
    attr_reader_from_doc_with_nil_default(:tagline) do
      info_node = (@doc/"//div.info/h5:contains('Tagline:')/..").first
      info_node.inner_text.gsub(/^\s*Tagline:\s+|\s*more\s*$/,'').strip
    end
    
    attr_reader_from_doc_with_nil_default(:company) do
      info_node = (@doc/"//div.info/h5:contains('Company:')/../a").first
      IMDB::Company.new(info_node.attributes['href'].split('/')[-1], info_node.inner_text)
    end
    
    attr_reader_from_doc_with_nil_default(:plot) do
      info_node = (@doc/"//div.info/h5:contains('Plot:')/..").first
      info_node.inner_text.gsub(/^\s*Plot:\s+| full summary \| full synopsis\s*$/,'').strip
    end
    
    attr_reader_from_doc_with_nil_default(:runtime) do
      info_node = (@doc/"//div.info/h5:contains('Runtime:')/..").first
      info_node.inner_text.gsub(/^\s*Runtime:\s+|\s*more\s*$/,'').strip
    end
    
    attr_reader_from_doc_with_nil_default(:release_date) do
      info_node = (@doc/"//div.info/h5:contains('Release'):contains('Date:')/..").first
      Date.parse(info_node.inner_text.gsub(/^\s*Release Date:\s+|\s*more\s*$/,''))
    end
    
    attr_reader_from_doc_with_empty_array_default(:directors) do
      info = (@doc/"//div.info/h5:contains('Director')/..").inner_html
      info.scan(/<a href="\/name\/([^"]+)\/">([^<]+)<\/a>(?: \(([^)]+)\))?/).map {|vals| IMDB::Name.new(vals[0], vals[1], vals[2])}
    end

    attr_reader_from_doc_with_empty_array_default(:writers) do
      info = (@doc/"//div.info/h5:contains('Writer')/..").inner_html
      info.scan(/<a href="\/name\/([^"]+)\/">([^<]+)<\/a>(?: \(([^)]+)\))?/).map {|vals| IMDB::Name.new(vals[0], vals[1], vals[2])}
    end

    attr_reader_from_doc_with_empty_array_default(:genres) do
      genres = (@doc/"//div.info/h5:contains('Genre')/../a").map {|elem| elem.inner_text} - ['more']
      ### TODO: if name and ID are the same in all cases (and they are) we should pass it once
      genres.map {|genre| IMDB::Genre.new(genre, genre)}
    end
    
    def initialize(text = nil)
      return self unless text

      ### TODO: Take a URL?      
      @src = text.class == Array ? text.join : text
      @doc = Hpricot(@src)
    end
    
    def type
      self.class.to_s.split(':')[-1].downcase
    end
  end
end