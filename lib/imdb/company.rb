class IMDB
  class Company
    attr_accessor :id, :name
  
    def initialize(*args)
      if args[0].class == Nokogiri::XML::Element
        args = [args[0]['href'].to_s.split('/')[-1], args[0].inner_text]
      end
    
      self.id = args[0];
      self.name = args[1];
    end
  end
end