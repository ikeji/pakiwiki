#!/usr/local/bin/ruby

require 'iconv'
require '../storage.rb'
require '../text_storage.rb'

PUKIWIKICODE = 'EUC-JP'
PAKIWIKICODE = 'UTF-8'

def pucode(str)
  return Iconv.conv(PUKIWIKICODE, PAKIWIKICODE, str)
end
def pacode(str)
  return Iconv.conv(PAKIWIKICODE, PUKIWIKICODE, str)
end

if ARGV.size < 2
  puts "Usage: #{$0} <inputdir> <outputdir>"
  exit
end

Dir["#{ARGV[0]}/*.txt"].each do|f|
  f =~ /\/([^\/]*)\.txt\Z/
  puwiki_encoded_name = $1
  realname = pacode(puwiki_encoded_name.gsub(/(..)/){$1.hex.chr})
  pawiki_encoded_name = TextStorage.new.escape(realname)

  puts "Convert: #{puwiki_encoded_name}.txt to #{pawiki_encoded_name}.txt"
  puts "Page: #{realname}"

  File.open(f) do |r|
    pafile = ARGV[1] + "/" + pawiki_encoded_name + ".txt"
    File.open(pafile ,"w") do |w|
      w.write pacode(r.read)
    end
  end
end
