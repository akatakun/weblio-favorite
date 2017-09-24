require './lib/api/weblio'

class Dictionary < ActiveRecord::Base
  class << self
    def search(word)
      kaki, yomi, body = API::Weblio.search(word)
      return if kaki.nil? || kaki == ''
      return if body !~ /\A\R*(.+?)\R*\Z/m

      obj = find_or_initialize_by(
        kaki: kaki,
      )
      obj.yomi = yomi
      obj.body = body
      obj
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
