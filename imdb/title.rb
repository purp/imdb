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

    attr_accessor :id, :title, :directors, :writers, :tagline, :company, :plot, :runtime, :rating, :poster_url, :release_date, :genres

    def id
      if !@id && @doc
        @id = File.basename((@doc%"link[@rel='canonical']").attributes['href'])
      end
      @id
    end

    def title
      if !@title && @doc
        @title = @doc.at("meta[@name='title']")['content'].gsub(/\(\d{4}\)/,'').strip
      end
      @title
    end

    def initialize(text = nil)
      return self unless text

      ### TODO: Take a URL?      
      @src = text.class == Array ? text.join : text
      @doc = Hpricot(@src)

      rating_text = (@doc/"div.rating/div.meta/b").inner_text
      if rating_text =~ /([\d\.]+)\/10/
        @rating = $1
      end

      begin
        @poster_url = @doc.at("div.photo/a[@name='poster']/img")['src']
      rescue
        @poster_url = nil
      end

      infos = (@doc/"div.info")
      infos.each do |info|
        info_title = (info/"h5").inner_text
        case info_title
        when /Directors?:/
          @directors = self.class.parse_names(info)
        when /Writers?[^:]+:/
          @writers = self.class.parse_names(info)
        when /Company:/
          @company = self.class.parse_company(info)
        when "Tagline:"
          @tagline = self.class.parse_info(info).strip
        when "Runtime:"
          @runtime = self.class.parse_info(info).strip
        when "Plot:"
          @plot = self.class.parse_info(info).strip
          @plot = @plot.gsub(/\s*\|\s*add synopsis$/, '')
          @plot = @plot.gsub(/\s*\|\s*full synopsis$/, '')
          @plot = @plot.gsub(/full summary$/, '')
          @plot = @plot.strip
        when "Genre:"
          @genres = self.class.parse_genres(info)
        when "Release Date:"
          begin
            if (self.class.parse_info(info).strip =~ /(\d{1,2}) ([a-zA-Z]+) (\d{4})/)
              @release_date = Date.parse("#{$2} #{$1}, #{$3}");
            end
          rescue
            @release_date = nil;
          end
        end
      end 
    end

    def writers
      @writers ? @writers : @writers = []
    end
    
    def directors
      @directors ? @directors : @directors = []
    end
    
    def genres
      @genres ? @genres : @genres = []
    end
    
    def type
      self.class.to_s.split(':')[-1].downcase
    end
  end
  
  protected
  
  def self.parse_info(info)
    value = info.inner_text.gsub(/\n/,'') 
    if value =~ /\:(.+)/ 
      value = $1
    end
    value.gsub(/ more$/, '')
  end
  
  def self.parse_names(info)
    # <a href="/name/nm0083348/">Brad Bird</a><br/><a href="/name/nm0684342/">Jan Pinkava</a> (co-director)<br/>N
    info.inner_html.scan(/<a href="\/name\/([^"]+)\/">([^<]+)<\/a>( \(([^)]+)\))?/).map do |match|
      IMDB::Name.new(match[0], match[1], match[3])
    end
  end
  
  def self.parse_company(info)
    # <a href="/company/co0017902/">Pixar Animation Studios</a>
    match = info.inner_html =~ /<a href="\/company\/([^"]+)\/">([^<]+)<\/a>/;
    IMDB::Company.new($1, $2)
  end

  def self.parse_genres(info)
    # <a href="/Sections/Genres/Animation/">Animation</a> / <a href="/Sections/Genres/Adventure/">Adventure</a>
    genre_links = (info/"a").find_all do |link|
      link['href'] =~ /^\/Sections\/Genres/
    end 
    genre_links.map do |link|
      genre = link['href'] =~ /([^\/]+)\/$/
      IMDB::Genre.new($1, $1)
    end
  end
end