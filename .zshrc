function webadd() {
  prev_dir=`pwd`
  cd ~/development/ruby/weblio-favorite/
  bundle exec ruby add.rb $1
  cd $prev_dir
}

function webget() {
  prev_dir=`pwd`
  cd ~/development/ruby/weblio-favorite/
  bundle exec ruby get.rb $1
  cd $prev_dir
}