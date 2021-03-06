require 'active_record'
require 'yaml'

config = YAML.load_file('./config/database.yml')
ActiveRecord::Base.establish_connection(
  config['development'],
)

require './model/dictionary'
require './model/category'
require './model/dictionary_tag'
require './model/tag'
