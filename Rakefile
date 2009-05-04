require 'rake'
require 'spec/rake/spectask'
require 'open-uri'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..')
SPEC_DIR = File.join(File.dirname(__FILE__), 'spec')
FIXTURE_DIR = File.join(SPEC_DIR, 'fixtures')
SPECS = "#{SPEC_DIR}/*_spec.rb"

### Inspired by http://blog.labratz.net/articles/2006/12/2/a-rake-task-for-rcov
begin
  require 'rcov/rcovtask'

  Spec::Rake::SpecTask.new do |t|
    t.libs << SPEC_DIR
    t.pattern = 'spec/*_spec.rb'
    t.rcov = true
    t.rcov_dir = "#{SPEC_DIR}/coverage"
    t.rcov_opts = ['--exclude', 'lib/core_ext.rb', '--exclude', '"spec/*"']
    t.verbose = true
  end
  
  desc "Generate and open coverage reports"
  task :rcov do
    system "open #{SPEC_DIR}/coverage/index.html"
  end
  task :rcov => :spec
rescue LoadError
  Spec::Rake::SpecTask.new do |t|
    t.libs << SPEC_DIR
    t.pattern = 'spec/*_spec.rb'
    t.verbose = true
  end
end

desc "Refresh test fixtures from IMDB"
task :refresh_fixtures do
  fixtures = %w(title/tt0382932 title/tt0075529 title/tt0636646 title/tt0636615 title/tt0374692)
  fixtures.each do |fixture|
    src = open("http://www.imdb.com/#{fixture}")
    dst = open(File.join(FIXTURE_DIR, fixture), 'w')
    dst.puts(src.readlines)
  end
end
