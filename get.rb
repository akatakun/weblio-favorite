require './initializer/active_record'
require './lib/api/weblio'

require 'optparse'

args = ARGV.getopts('n:', 'slim', 'loop', 'latest')

LATEST_OFFSET_NUMBER = 25

case ARGV.size
when 0
  begin
    sleep 1 if args['loop']
    limit = args['n'] || 1
    if args['latest']
      Dictionary.offset(Dictionary.count - LATEST_OFFSET_NUMBER + rand(LATEST_OFFSET_NUMBER)).limit(limit)
    else
      Dictionary.offset(rand(Dictionary.count)).limit(limit)
    end.each do |dictionary|
      dictionary.display(args['slim'])
    end
  end while args['loop']
when 1
  kaki, yomi, body = API::Weblio.search(ARGV[0])
  dictionary = Dictionary.find_or_initialize_by(
    kaki: kaki,
  )
  dictionary.yomi = yomi || kaki
  dictionary.body = body

  dictionary.display(args['slim'])
end

