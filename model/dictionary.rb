class Dictionary < ActiveRecord::Base
  def display(slim = false)
    if !slim
      puts "#{self.kaki}(#{self.yomi})\n#{self.body}"
    else
      puts "#{self.kaki}(#{self.yomi})"
    end
  end
end
