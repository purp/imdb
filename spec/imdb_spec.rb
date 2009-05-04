require 'spec_helper'
require 'imdb'

describe IMDB do
  it "should have an imdb movie base url" do
    IMDB::Title::BASE_URL.should eql("http://www.imdb.com/title/")
  end
  it "should have an imdb search base url" do
    IMDB::SEARCH_BASE_URL.should eql("http://imdb.com/find?s=all&q=")
  end
end

def it_should_have_appropriate_readers_with_proper_defaults
  it "should have appropriate readers with proper defaults" do
    @test_obj.class::ATTRIBUTES.each do |attr_sym, opts|
      @test_obj.should respond_to(attr_sym)
      @test_obj.should respond_to("#{attr_sym}_from_doc".to_sym)
      @test_obj.send(attr_sym).should == opts[:default]
    end
  end
end

describe IMDB::Title, "when first created" do
  before(:each) do
    @test_obj = IMDB::Title.new
  end
  
  it_should_have_appropriate_readers_with_proper_defaults
end

describe IMDB::Movie, "when first created" do
  before(:each) do
    @test_obj = IMDB::Movie.new
  end
  
  it_should_have_appropriate_readers_with_proper_defaults
end

describe IMDB::Series, "when first created" do
  before(:each) do
    @test_obj = IMDB::Series.new
  end
  
  it_should_have_appropriate_readers_with_proper_defaults
end

describe IMDB::Episode, "when first created" do
  before(:each) do
    @test_obj = IMDB::Episode.new
  end
  
  it_should_have_appropriate_readers_with_proper_defaults
end


describe IMDB::Title, "finders" do
  before(:all) do
    silence_warnings {IMDB::Title::BASE_URL = File.join(FIXTURE_DIR, 'title', '')}
  end
  
  it "should find by IMDB id and return an IMDB::Title or subclass which responds with non-nil values" do
    {'tt0382932' => IMDB::Movie, 'tt0075529' => IMDB::Series, 'tt0636646' => IMDB::Episode, 'tt0636615' => IMDB::Episode, 'tt0374692' => IMDB::Title}.each do |title_id, klass|
      title = IMDB::Title.find_by_id(title_id)
      title.kind_of?(IMDB::Title).should be_true
      title.instance_of?(klass).should be_true
      title.id.should == title_id
      title.type.should == klass.to_s.split(':')[-1].downcase
      title.class::ATTRIBUTES.each do |attr_sym, opts|
        unless (title_id == 'tt0636615' && [:runtime, :company, :country].include?(attr_sym))
          # puts ">>> #{title_id}.#{attr_sym}"
          title.send(attr_sym).should_not == opts[:default]
        else
          title.send(attr_sym).should be_nil
        end
      end
    end
  end
end

describe IMDB::Movie, "after a IMDB::Title.find_by_id returns it" do 
  before(:all) do
    silence_warnings {IMDB::Title::BASE_URL = File.join(FIXTURE_DIR, 'title', '')}
  end
  
  before(:each) do
    @movie = IMDB::Title.find_by_id('tt0382932') # Ratatouille by Pixar
  end
  
  it "should have an id" do
    @movie.id.should == 'tt0382932'
  end
  
  it "should have a url" do
    @movie.url.should == "http://www.imdb.com/title/tt0382932/"
  end
    
  it "should have a title" do
    @movie.title.should eql('Ratatouille')
  end

  it "should have a release date" do
    @movie.release_date.should eql(Date.new(2007, 06, 29))
  end

  it "should have a company" do
    @movie.company.id.should eql('co0017902')
    @movie.company.name.should eql('Pixar Animation Studios')
    @movie.company.class.should == IMDB::Company
  end

  it "should have two directors" do
    @movie.directors.length.should == 2
    @movie.directors[0].id.should eql('nm0083348')
    @movie.directors[0].name.should eql('Brad Bird')
    @movie.directors[0].role.should eql(nil)
    @movie.directors[0].class.should == IMDB::Name

    @movie.directors[1].id.should eql('nm0684342')
    @movie.directors[1].name.should eql('Jan Pinkava')
    @movie.directors[1].role.should eql('co-director')
    @movie.directors[1].class.should == IMDB::Name
  end

  it "should have two writers" do
    @movie.writers.length.should == 2
    @movie.writers[0].id.should eql('nm0083348')
    @movie.writers[0].name.should eql('Brad Bird')
    @movie.writers[0].role.should eql('screenplay')
    @movie.writers[0].class.should == IMDB::Name

    @movie.writers[1].id.should eql('nm0684342')
    @movie.writers[1].name.should eql('Jan Pinkava')
    @movie.writers[1].role.should eql('story')
    @movie.writers[1].class.should == IMDB::Name
  end

  it "should have three genres" do
    @movie.genres.length.should == 3
    @movie.genres[0].name.should eql('Animation')
    @movie.genres[1].name.should eql('Comedy')
    @movie.genres[2].name.should eql('Family')
    @movie.genres.each do |genre|
      genre.class.should == IMDB::Genre
      genre.kind_of?(IMDB::Section).should be_true
    end
  end

  it "should have a tagline" do
    @movie.tagline.should eql('Dinner is served... Summer 2007')
  end
  
  it "should have a rating" do
    @movie.rating.should =~ /\d.\d/
  end
  
  it "should have a poster_url" do
    @movie.poster_url.should =~ /http:\/\/.*\.jpg/
  end

  it "should have a runtime" do
    @movie.runtime.should =~ /\d+ min/
  end
  
  it "should have a plot" do
    @movie.plot.should eql(%{Remy is a young rat in the French countryside who arrives in Paris, only to find out that his cooking idol is dead. When he makes an unusual alliance with a restaurant's new garbage boy, the culinary and personal adventures begin despite Remy's family's skepticism and the rat-hating world of humans.})
  end
  
  it "should have a year" do
    @movie.year.name.should == '2007'
    @movie.year.to_s.should == '2007'
    @movie.year.class.should == IMDB::Year
    @movie.year.kind_of?(IMDB::Section).should be_true
  end
  
  it "should have two languages" do
    @movie.languages.length.should == 2
    @movie.languages[0].name.should == 'English'
    @movie.languages[1].name.should == 'French'
    @movie.languages.each do |language|
      language.class.should == IMDB::Language
      language.kind_of?(IMDB::Section).should be_true
    end
  end
  
  it "should have a country" do
    @movie.country.name.should == 'USA'
    @movie.country.to_s.should == 'USA'
    @movie.country.class.should == IMDB::Country
    @movie.country.kind_of?(IMDB::Section).should be_true
  end
end

