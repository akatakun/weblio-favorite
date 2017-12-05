require 'open-uri'
require 'nokogiri'

module API
  class Kotobank
    DICT_URI = 'http://kotobank.jp/word'

    class << self
      def fetch_dom(query)
        charset = nil

        html = open("#{DICT_URI}/#{URI.encode(query)}") do |f|
          charset = f.charset
          f.read
        end

        Nokogiri::HTML.parse(html, nil, charset)
      end

      def search(query, index = nil)
        kaki = nil
        yomi = nil
        body = nil

        self.fetch_dom(query).xpath('//div[@class="ex cf"]').tap do |bodies|
          break if bodies.size < 1
          indexes = index ? (index..index) : (0..4)
          indexes.each do |index|
            body = bodies[index]
            next if body.nil?

            match = body.css('h3').first.text.match(/(.+?)【(.+?)】/)
            next if match.nil?

            kaki = query
            yomi = match[1]
            body = body.css('section').text
            break
          end
        end

        [kaki, yomi, body]
      rescue OpenURI::HTTPError
        nil
      end
    end
  end
end
