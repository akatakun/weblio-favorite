require './initializer/active_record'

raise 'String for search as argument is required' if ARGV.size < 1

case ARGV.size
when 1
  dict = Dictionary.search(ARGV[0], nil)
when 2
  dict = Dictionary.find_or_initialize_by(
    kaki: ARGV[0],
  )
  dict.body = ARGV[1]
end

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
