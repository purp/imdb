require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'date'

require 'core_ext'

# # Dynamically load all core libraries.
# 
# __DIR__ = File.dirname(__FILE__)
# 
# list = []
# Dir.chdir("#{__DIR__}/imdb") do
#   list = Dir['*'].map {|file| File.basename(file, ".rb")}
#   puts ">>> #{list.inspect}"
# end
# 
# list.each{ |f| require "imdb/#{f}" }


require 'imdb/base'
require 'imdb/title'
require 'imdb/company'
require 'imdb/movie'
require 'imdb/name'
require 'imdb/genre'
require 'imdb/series'
require 'imdb/episode'

# For compatibility with the old skool way of doing things
require 'imdb/old_skool_compatibility'