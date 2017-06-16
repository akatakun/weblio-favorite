class Dictionary < ActiveRecord::Base
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
