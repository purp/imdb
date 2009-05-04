class IMDB
  class Title < IMDB
    BASE_URL = "http://www.imdb.com/title/"
    
    ATTRIBUTES = {
      :url => {:expr => "link[@rel='canonical']", :post => Proc.new {|n| n['href'].to_s}},
      :title => {:expr => "meta[@name='title']", :post => Proc.new {|n| n['content'].gsub(/\(\d{4}\)/,'').strip}},
      :poster_url => {:expr => "div.photo/a/img", :post => Proc.new {|n| n['src']}},
      :rating => {:expr => "div.rating/div.meta/b", :post => Proc.new {|n| n.inner_text.match(/[^\/]+/).to_s}},
      :plot => {:expr => "div.info[contains('Plot:', h5)]", :post => Proc.new {|n| n.inner_text.split(/\n|\s*full (?:summary|synopsis)\s*\|?/)[-1]}},
      :company => {:expr => "div.info[contains('Company:', h5)]/a", :post => Proc.new {|n| IMDB::Company.new(n)}},
      :directors => {:expr => "div.info[contains('Director', h5)]", :post => Proc.new {|n| IMDB::Name.get_names(n)}, :default => []},
      :writers => {:expr => "div.info[contains('Writer', h5)]", :post => Proc.new {|n| IMDB::Name.get_names(n)}, :default => []},
      :genres => {:expr => "div.info[contains('Genre', h5)]", :post => Proc.new {|n| IMDB::Genre.get_genres(n)}, :default => []},
      :year => {:expr => "meta[@name='title']", :post => Proc.new {|n| IMDB::Year.new(n['content'].match(/(\d+)\)(?:\s*\(VG\)\s*)?$/).captures.first)}},
      :languages => {:expr => "div.info[contains('Language', h5)]", :post => Proc.new {|n| IMDB::Language.get_languages(n)}, :default => []},
      :country => {:expr => "div.info[contains('Country:', h5)]/a", :post => Proc.new {|n| IMDB::Country.new(n)}},
    }

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
    
    generate_cached_attr_readers(ATTRIBUTES)
    
    def initialize(text = nil)
      return self unless text

      ### TODO: Take a URL?      
      @src = text.class == Array ? text.join : text
      @doc = Nokogiri::HTML(@src)
    end
    
    def id
      url.split('/')[-1] if url
    end
    
    def type
      self.class.to_s.split(':')[-1].downcase
    end
  end
end