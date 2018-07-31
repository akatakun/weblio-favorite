class Tag < ActiveRecord::Base
  has_many :dictionaries, through: :dictionary_tags
  has_many :dictionary_tags
end
