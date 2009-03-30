$LOAD_PATH << File.join(File.dirname(__FILE__), '..')
FIXTURE_DIR = File.join(File.dirname(__FILE__), 'fixtures')

require 'open-uri'

# Stolen from Facets http://facets.rubyforge.org/
def silence_warnings
  old_verbose, $VERBOSE = $VERBOSE, nil
  yield
ensure
  $VERBOSE = old_verbose
end

def refresh_fixtures
  fixtures = %w(title/tt0382932)
  fixtures.each do |fixture|
    src = open("http://www.imdb.com/#{fixture}")
    dst = open(File.join(FIXTURE_DIR, fixture), 'w')
    dst.puts(src.readlines)
  end
end
