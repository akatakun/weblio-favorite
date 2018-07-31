require './initializer/active_record'

require 'optparse'

raise 'String for search as argument is required' if ARGV.size < 1

args = ARGV.getopts('c:', 't:')

category = nil
if args['c']
  category = Category.find_or_create_by(
    name: args['c'],
  )
end
tags = []
if args['t']
  args['t'].split(',').each do |tag|
    tags << Tag.find_or_create_by(
      name: tag,
    )
  end
end

case ARGV.size
when 1
  dict = Dictionary.where(kaki: ARGV[0]).first || Dictionary.search(ARGV[0], nil)
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

dict.category_id = category.id if category
tags.each do |tag|
  dict.dictionary_tags.find_or_create_by(
    tag_id: tag.id,
  )
end

if !dict.new_record?
  print "## found record in database ##\n"
  dict.update(count: dict.count + 1)
end

dict.display

dict.save
