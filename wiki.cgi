#!/usr/local/bin/ruby

begin
# FIXME: 後で、これらのrequireとか、pluginを読み込んだ1ファイルを作るプログラムを作る。
require "./config.rb"
require "./plugin.rb"
require "./storage.rb"
require "./text_storage.rb"
require "./ast.rb"
require "./yatmlperser.rb"
require "./wabisabi.rb"
require "./converter.rb"
require "./template.rb"
require "./wiki.rb"

# startup
Wiki.new( __FILE__ == $0 )


rescue Exception => e
  puts "Content-Type: text/plain"
  puts 
  puts "Oops!!!"
  puts
  puts
  puts "Exception: " + e
  puts
  puts "Backtrace:"
  print e.backtrace.join("\n")

end

# vim: sw=2 : ts=1000 :
