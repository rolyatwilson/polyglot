require 'rubygems'
require 'active_support/core_ext/hash/keys'
require 'fileutils'
require 'google/cloud/translate'
require 'json'
require 'mustache'
require 'net/http'
require 'nokogiri'
require 'thor'

Dir.glob("#{__dir__}/**/*.rb") do |file|
  require file
end
