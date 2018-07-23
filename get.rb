require './initializer/active_record'
require './lib/api/weblio'

require 'optparse'

args = ARGV.getopts('n:', 'slim', 'head', 'loop', 'latest', 'weight')

LATEST_OFFSET_NUMBER = 25

case ARGV.size
when 0
  begin
    sleep 1 if args['loop']
    limit = args['n'] || 1
    case
    when args['latest']
      Dictionary.pick_latest_randomly(LATEST_OFFSET_NUMBER).limit(limit)
    when args['weight']
      Dictionary.pick_randomly_with_count_as_weight.limit(limit)
    else
      Dictionary.pick_randomly.limit(limit)
    end.each do |dictionary|
      dictionary.display(args)
    end
  end while args['loop']
else
  dict = Dictionary.where(kaki: ARGV[0]).first || Dictionary.search(ARGV[0], ARGV[1] ? ARGV[1].to_i : nil)
  if dict.nil?
    print "検索結果が見つかりませんでした\n"
    exit
  end

  if !dict.new_record?
    print "## found record in database ##\n"
    dict.update(count: dict.count + 1)
  end

  dict.display()

  if dict.new_record?
    print "Do you add a new record? [y/n]:"
    case $stdin.gets.chomp
    when /^[yY]/
      dict.save
      puts 'it is saved!'
    end
  end
end

