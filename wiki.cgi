#!/usr/local/bin/ruby

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

# vim: sw=2 : ts=1000 :
