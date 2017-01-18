require './initializer/active_record'
require './lib/api/weblio'

raise 'String for search as argument is required' if ARGV.size < 1

yomi, kaki, body = API::Weblio.search(ARGV[0])

dictionary = Dictionary.find_or_initialize_by(
  kaki: kaki,
)
dictionary.yomi = yomi || kaki
dictionary.body = body
dictionary.save

dictionary.display
