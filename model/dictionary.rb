require './lib/api/kotobank'
require './lib/api/weblio'
require 'pry'

class Dictionary < ActiveRecord::Base
  class << self
    def search(word, index = 0)
      [API::Kotobank.search(word, index), API::Weblio.search(word)].each do |kaki, yomi, body|
        next if kaki.nil? || kaki == ''

        body !~ /\A\R*(.+?)\R*\Z/m
        next if $1.nil?
        body = $1.strip

        obj = find_or_initialize_by(
          kaki: kaki,
        )
        obj.yomi = yomi
        obj.body = body
        return obj
      end
      nil
    end
  end

  def display(option = {})
    case
    when option['slim']
      puts "#{self.kaki}(#{self.yomi})\n#{self.body[0..99]}"
    when option['head']
      puts "#{self.kaki}(#{self.yomi})"
    else
      puts "#{self.kaki}(#{self.yomi})\n#{self.body}"
    end
  end
end
