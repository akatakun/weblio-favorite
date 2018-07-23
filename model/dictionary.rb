require './lib/api/kotobank'
require './lib/api/weblio'

class Dictionary < ActiveRecord::Base
  belongs_to :category

  class << self
    def search(word, index = nil)
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
      puts "[#{sprintf("%03d", self.count)}]#{self.kaki}(#{self.yomi})#{!self.category.nil? ? " ##{self.category.name}" : ""}\n#{self.body[0..99]}"
    when option['head']
      puts "[#{sprintf("%03d", self.count)}]#{self.kaki}(#{self.yomi})#{!self.category.nil? ? " ##{self.category.name}" : ""}"
    else
      puts "[#{sprintf("%03d", self.count)}]#{self.kaki}(#{self.yomi})#{!self.category.nil? ? " ##{self.category.name}" : ""}\n#{self.body}"
    end
  end
end
