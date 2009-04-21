class IMDB
  class Name
    def self.get_names(node)
      return unless node && node.class == Nokogiri::XML::Element
      names = []
      node.inner_html.split(/\n|<br>/).each do |chunk|
        next unless chunk =~ /href="\/name\/nm\d+\/"/
        names << IMDB::Name.new(chunk)
      end
      names
    end
    
    attr_accessor :id, :name, :role
  
    def initialize(*args)
      if args.size == 1 && args[0].class == String
        # Init from HTML data like: <a href="/name/nm0684342/">Jan Pinkava</a> (co-director)
        args = args[0].scan(/<a href="\/name\/([^"]+)\/">([^<]+)<\/a>(?: \(([^)]+)\))?/)
      end
      
      # We'll also handle an array if passed
      args = args[0] if args[0].class == Array
      
      self.id = args[0]
      self.name = args[1]
      self.role = args[2]
    end
  end
end