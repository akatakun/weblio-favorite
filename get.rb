require './initializer/active_record'
require './lib/api/weblio'

require 'optparse'

args = ARGV.getopts('n:', 'slim', 'latest')

LATEST_OFFSET_NUMBER = 5

case ARGV.size
when 0
  limit = args['n'] || 1
  if args['latest']
    Dictionary.offset(Dictionary.count - LATEST_OFFSET_NUMBER + rand(LATEST_OFFSET_NUMBER)).limit(limit)
  else
    Dictionary.offset(rand(Dictionary.count)).limit(limit)
  end.each do |dictionary|
    dictionary.display(args['slim'])
  end
when 1
  kaki, yomi, body = API::Weblio.search(ARGV[0])
  dictionary = Dictionary.find_or_initialize_by(
    kaki: kaki,
  )
  dictionary.yomi = yomi || kaki
  dictionary.body = body

  dictionary.display(args['slim'])
end

