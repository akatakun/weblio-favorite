require 'open-uri'
require 'nokogiri'

module API
  class Weblio
    DICT_URI = 'http://www.weblio.jp/content'

    class << self
      def fetch_dom(query)
        charset = nil

        html = open("#{DICT_URI}/#{URI.encode(query)}") do |f|
          charset = f.charset
          f.read
        end

        Nokogiri::HTML.parse(html, nil, charset)
      end

      def search(query)
        kaki = nil
        yomi = nil
        body = nil

        self.fetch_dom(query).xpath('//div[@class="kiji"]').tap do |bodies|
          break if bodies.size < 1
          body = bodies.first

          kaki = body.css('h2').first.attr('title').gsub(/\//, '')
          yomi = body.css('b').first
          yomi = yomi.text.gsub(/\s/, '') if yomi
          body = body.text
        end

        [kaki, yomi, body]
      rescue OpenURI::HTTPError
        nil
      end
    end
  end
end
