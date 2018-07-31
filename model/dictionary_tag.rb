class DictionaryTag < ActiveRecord::Base
  self.table_name = 'dictionaries_tags'

  belongs_to :dictionary
  belongs_to :tag
end
