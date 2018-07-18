require 'open-uri'
require 'nokogiri'

module API
  class Weblio
    DICT_URI = 'https://www.weblio.jp/content'

    class << self
      def fetch_dom(query)
        charset = nil

        html = open("#{DICT_URI}/#{URI.encode(query)}", ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE) do |f|
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

          kaki = query
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
