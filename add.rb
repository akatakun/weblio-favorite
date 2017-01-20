require './initializer/active_record'
require './lib/api/weblio'
require 'pry'

raise 'String for search as argument is required' if ARGV.size < 1

kaki, yomi, body = API::Weblio.search(ARGV[0])

if kaki.nil? or kaki == ''
  print "検索結果が見つかりませんでした\n"
  exit
end

if yomi.nil? or yomi == ''
  print "読み仮名が見つかりませんでした\n"
  print '読み仮名: '
  yomi = STDIN.gets.chomp
  print "\n"
end

dictionary = Dictionary.find_or_initialize_by(
  kaki: kaki,
)
dictionary.yomi = yomi
dictionary.body = body
dictionary.save

dictionary.display
