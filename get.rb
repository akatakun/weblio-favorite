require './initializer/active_record'
require './lib/api/weblio'

case ARGV.size
when 0
  Dictionary = Dictionary.offset(rand(Dictionary.count)).first
when 1
  yomi, kaki, body = API::Weblio.search(ARGV[0])
  dictionary = Dictionary.find_or_initialize_by(
    kaki: kaki,
  )
  dictionary.yomi = yomi || kaki
  dictionary.body = body
end

dictionary.display
