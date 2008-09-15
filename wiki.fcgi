#!/usr/local/bin/ruby

# FIXME: 後で、これらのrequireとか、pluginを読み込んだ1ファイルを作るプログラムを作る。
require "./plugin.rb"
require "./storage.rb"
require "./text_storage.rb"
require "./db_storage.rb"
require "./ast.rb"
require "./yatmlperser.rb"
require "./wabisabi.rb"
require "./converter.rb"
require "./template.rb"
require "./wiki.rb"
require "./config.rb"

$storage = STORAGE.new

require 'fcgi'

FCGI.each_cgi do |cgi|

begin
# startup
Wiki.new(true,cgi)

rescue Exception => e
  puts "Content-Type: text/plain"
  puts 
  puts "Oops!!!"
  puts
  puts
  puts "Exception: " + e.class.inspect
  puts e
  puts
  puts "Backtrace:"
  print e.backtrace.join("\n")

end
end

# vim: sw=2 : ts=1000 :
