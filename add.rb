require './initializer/active_record'
require 'pry'

raise 'String for search as argument is required' if ARGV.size < 1

dict = Dictionary.search(ARGV[0])

if dict.nil?
  print "検索結果が見つかりませんでした\n"
  exit
end

if dict.yomi.nil? || dict.yomi == ''
  print "読み仮名が見つかりませんでした\n"
  print '読み仮名: '
  dict.yomi = STDIN.gets.chomp
  print "\n"
end

dict.save

dict.display
