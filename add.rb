require './initializer/active_record'
require './lib/api/weblio'

raise 'String for search as argument is required' if ARGV.size < 1

kaki, yomi, body = API::Weblio.search(ARGV[0])

dictionary = Dictionary.find_or_initialize_by(
  kaki: kaki,
)
dictionary.yomi = yomi
dictionary.body = body

if dictionary.yomi.nil? or dictionary.yomi == ''
  print "読み仮名が見つかりませんでした\n"
  print '読み仮名: '
  dictionary.yomi = STDIN.gets.chomp
  print "\n"
end

dictionary.save

dictionary.display
