class Dictionary < ActiveRecord::Base
  def display
    puts "#{self.kaki}(#{self.yomi})\n#{self.body}"
  end
end
