#!/usr/bin/env ruby

require 'active_record'
require 'open-uri'
require 'nokogiri'
require 'yaml'

raise 'String for search as argument is required' if ARGV.size < 1

content = URI.encode(ARGV[0])
dic_uri = "http://www.weblio.jp/content/#{content}"
the_uri = "http://thesaurus.weblio.jp/content/#{content}"

charset = nil

html = open(dic_uri) do |f|
  charset = f.charset
  f.read
end
doc = Nokogiri::HTML.parse(html, nil, charset)

kaki = nil
yomi = nil
body = nil

#doc.xpath('//div[@class="NetDicHead"]').tap do |heads|
doc.xpath('//div[@class="kiji"]').tap do |bodies|
  break if bodies.size < 1
  body = bodies.first

  kaki = body.css('h2').first.attr('title')
  yomi = body.css('b').first
  yomi = yomi.text.gsub(/\s/, '') if yomi
  body = body.text
end

config = YAML.load_file('./config/database.yml')
ActiveRecord::Base.establish_connection(
  config['development'],
)

require './model/dictionary'

dictionary = Dictionary.find_or_create_by(
  kaki: kaki,
)
dictionary.yomi = yomi
dictionary.body = body
dictionary.save

puts "#{dictionary.kaki}(#{dictionary.yomi})"
puts dictionary.body
