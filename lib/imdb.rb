require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'

require 'core_ext'

### TODO: This doesn't work because I'm ignorant. I should figure this out and learn.
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
require 'imdb/series'
require 'imdb/episode'
require 'imdb/section'
require 'imdb/genre'
require 'imdb/year'
require 'imdb/language'
require 'imdb/country'


