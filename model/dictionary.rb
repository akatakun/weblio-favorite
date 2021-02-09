require './lib/api/kotobank'
require './lib/api/weblio'

class Dictionary < ActiveRecord::Base
  belongs_to :category
  has_many :dictionary_tags
  has_many :tags, through: :dictionary_tags

  class << self
    def pick_latest_randomly(latest_offset_number)
      offset(count - latest_offset_number + rand(latest_offset_number))
    end

    def pick_randomly_with_count_as_weight
      total_weight = 0
      group(:count).count.each do |weight, count|
        total_weight += (2 ** weight) * count
      end

      rnd = rand(total_weight)

      pick_w = 0
      pick_c = 0
      group(:count).count.each do |weight, count|
        w = (2 ** weight) * count
        if rnd < w
          pick_w = weight
          pick_c = count
          break
        end
        rnd -= w
      end

      where(count: pick_w).offset(rand(pick_c))
    end

    def pick_randomly
      offset(rand(count))
    end

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
      puts "[#{sprintf("%03d", self.count)}]#{self.kaki}(#{self.yomi})#{!self.category.nil? ? " @#{self.category.name}" : ""}#{!self.tags.size.zero? ? " #{self.tags.map{|t| "##{t.name}"}.join(" ")}" : ""}\n#{self.body[0..99]}"
    when option['head']
      puts "[#{sprintf("%03d", self.count)}]#{self.kaki}(#{self.yomi})#{!self.category.nil? ? " @#{self.category.name}" : ""}#{!self.tags.size.zero? ? " #{self.tags.map{|t| "##{t.name}"}.join(" ")}" : ""}"
    else
      puts "[#{sprintf("%03d", self.count)}]#{self.kaki}(#{self.yomi})#{!self.category.nil? ? " @#{self.category.name}" : ""}#{!self.tags.size.zero? ? " #{self.tags.map{|t| "##{t.name}"}.join(" ")}" : ""}\n#{self.body}"
    end
  end
end
