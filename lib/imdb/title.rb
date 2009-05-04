class IMDB
  class Title < IMDB
    BASE_URL = "http://www.imdb.com/title/"
    
    ### TODO: These should be hashes where values are blocks; then defining the readers is just iterating over the hash. I'm not smart enough to do this yet. I will be.
    SINGLE_VALUE_ATTRS = [:url, :id, :title, :poster_url, :rating, :plot, :company]
    MULTI_VALUE_ATTRS = [:directors, :writers, :genres]

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
    
    attr_reader_from_doc_with_nil_default(:url) do
      (@doc%"link[@rel='canonical']")['href'].to_s
    end
    
    attr_reader_from_doc_with_nil_default(:id) do
      url.split('/')[-1]
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
      @doc.at("div.photo/a/img")['src']
    end
    
    attr_reader_from_doc_with_nil_default(:company) do
      IMDB::Company.new(get_info_from_doc('Company:'))
    end
    
    attr_reader_from_doc_with_nil_default(:plot) do
      info = get_info_from_doc('Plot:').inner_text
      info.gsub(/^\s*Plot:\s+|\s*full summary\s*\|\s*full synopsis\s*$/,'')
    end
    
    attr_reader_from_doc_with_empty_array_default(:directors) do
      IMDB::Name.get_names(get_info_from_doc('Director'))
    end

    attr_reader_from_doc_with_empty_array_default(:writers) do
      IMDB::Name.get_names(get_info_from_doc('Writer'))
    end

    attr_reader_from_doc_with_empty_array_default(:genres) do
      IMDB::Genre.get_genres(get_info_from_doc('Genre'))
    end
    
    def initialize(text = nil)
      return self unless text

      ### TODO: Take a URL?      
      @src = text.class == Array ? text.join : text
      @doc = Nokogiri::HTML(@src)
    end
    
    def type
      self.class.to_s.split(':')[-1].downcase
    end
    
    protected
    
    def get_info_from_doc(name)
      node = (@doc%"div[@class = 'info']/h5[contains('#{name}')]")
      node ? node.parent : nil
    end
  end
end