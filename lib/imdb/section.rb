class IMDB
  class Section
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def url
      "#{BASE_URL}/#{name}"
    end
  end
end
