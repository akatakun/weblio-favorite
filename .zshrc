function webget() {
  prev_dir=`pwd`
  cd ~/development/ruby/weblio-favorite/
  bundle exec ruby get.rb --weight $@ 2> /dev/null
  cd $prev_dir
}

function webadd() {
  prev_dir=`pwd`
  cd ~/development/ruby/weblio-favorite/
  bundle exec ruby add.rb $@ 2> /dev/null
  cd $prev_dir
}
