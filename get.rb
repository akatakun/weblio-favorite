require './initializer/active_record'

dictionary = Dictionary.offset(rand(Dictionary.count)).first

dictionary.display
