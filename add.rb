#!/usr/bin/env ruby

require './initializer/active_record'
require 'open-uri'
require 'nokogiri'

raise 'String for search as argument is required' if ARGV.size < 1

content = URI.encode(ARGV[0])
dic_uri = "http://www.weblio.jp/content/#{content}"

charset = nil

html = open(dic_uri) do |f|
  charset = f.charset
  f.read
end
doc = Nokogiri::HTML.parse(html, nil, charset)

kaki = nil
yomi = nil
body = nil

doc.xpath('//div[@class="kiji"]').tap do |bodies|
  break if bodies.size < 1
  body = bodies.first

  kaki = body.css('h2').first.attr('title')
  yomi = body.css('b').first
  yomi = yomi.text.gsub(/\s/, '') if yomi
  body = body.text
end

dictionary = Dictionary.find_or_create_by(
  kaki: kaki,
)
dictionary.yomi = yomi || kaki
dictionary.body = body
dictionary.save

dictionary.display
