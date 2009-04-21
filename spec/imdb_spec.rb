require 'spec_helper'
require 'imdb'

TITLE_SINGLE_VALUE_ATTRS = [:url, :id, :title, :rating, :plot]
TITLE_MULTI_VALUE_ATTRS = [:directors, :writers, :genres]

describe IMDB do
  it "should have an imdb movie base url" do
    IMDB::Title::BASE_URL.should eql("http://www.imdb.com/title/")
  end
  it "should have an imdb search base url" do
    IMDB::SEARCH_BASE_URL.should eql("http://imdb.com/find?s=all&q=")
  end
end

describe IMDB::Title, "when first created" do
  before(:each) do
    @title = IMDB::Title.new
  end
  
  it "should have appropriate readers" do
    [TITLE_SINGLE_VALUE_ATTRS + TITLE_MULTI_VALUE_ATTRS].flatten.each do |attr_sym|
      @title.should respond_to(attr_sym)
      @title.should respond_to("#{attr_sym}_from_doc".to_sym)
    end
  end
  
  it "should default list readers to empty arrays" do
    TITLE_MULTI_VALUE_ATTRS.each do |attr_sym|
      @title.send(attr_sym).should == []
    end
  end
      
  it "should default non-list accessors to nil" do
    TITLE_SINGLE_VALUE_ATTRS.each do |attr_sym|
      @title.send(attr_sym).should be_nil
    end
  end
  
  it "should return an empty array if writers is nil" do
    @title.instance_variable_set('@writers', nil)
    @title.writers.should == []
  end

  it "should return an empty array if directors is nil" do
    @title.instance_variable_set('@directors', nil)
    @title.directors.should == []
  end

  it "should return an empty array if genres is nil" do
    @title.instance_variable_set('@genres', nil)
    @title.genres.should == []
  end
end

describe IMDB::Title, "finders" do
  before(:all) do
    silence_warnings {IMDB::Title::BASE_URL = File.join(FIXTURE_DIR, 'title', '')}
  end
  
  it "should find by IMDB id and return an IMDB::Title or subclass which responds with non-nil values" do
    {'tt0382932' => IMDB::Movie, 'tt0075529' => IMDB::Series, 'tt0636615' => IMDB::Episode}.each do |title_id, klass|
      title = IMDB::Title.find_by_id(title_id)
      title.kind_of?(IMDB::Title).should be_true
      title.instance_of?(klass).should be_true
      title.id.should == title_id
      TITLE_MULTI_VALUE_ATTRS.each do |attr_sym|
        title.send(attr_sym).should_not == []
      end
      TITLE_SINGLE_VALUE_ATTRS.each do |attr_sym|
        title.send(attr_sym).should_not be_nil
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
  end

  it "should have two directors" do
    @movie.directors.length.should == 2
    @movie.directors[0].id.should eql('nm0083348');
    @movie.directors[0].name.should eql('Brad Bird');
    @movie.directors[0].role.should eql(nil);

    @movie.directors[1].id.should eql('nm0684342');
    @movie.directors[1].name.should eql('Jan Pinkava');
    @movie.directors[1].role.should eql('co-director');
  end

  it "should have two writers" do
    @movie.writers.length.should == 2
    @movie.writers[0].id.should eql('nm0083348');
    @movie.writers[0].name.should eql('Brad Bird');
    @movie.writers[0].role.should eql('screenplay');

    @movie.writers[1].id.should eql('nm0684342');
    @movie.writers[1].name.should eql('Jan Pinkava');
    @movie.writers[1].role.should eql('story');
  end

  it "should have five genres" do
    @movie.genres.length.should == 3
    @movie.genres[0].name.should eql('Animation');
    @movie.genres[1].name.should eql('Comedy');
    @movie.genres[2].name.should eql('Family');
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
end

