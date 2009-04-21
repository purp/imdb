class IMDB
  class Company
    attr_accessor :id, :name
  
    def initialize(*args)
      if args[0].class == Nokogiri::XML::Element
        link = (args[0]/"a").first
        args = [link['href'].to_s.split('/')[-1], link.inner_text]
      end
    
      self.id = args[0];
      self.name = args[1];
    end
  end
end