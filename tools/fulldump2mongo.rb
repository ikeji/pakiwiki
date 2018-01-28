# !/usr/local/bin/ruby
# coding: UTF-8


INPUT_FILE = ARGV[0]

puts "Load from #{INPUT_FILE}"

require 'mongo'
require 'uri'
require 'json'
    
if (ENV['MONGOHQ_URL'] != nil)
  $db = Mongo::Client.new(ENV['MONGOHQ_URL'])
else
  $db = Mongo::Client.new().db('wikidb')
end
$coll = $db[:pages]

data = JSON.parse(File.read(INPUT_FILE))

data.each_pair do |k,vs|
  title = k
  p title
  vs.each do |v|
    time = Time.at(v['unixtime'])
    data = v['data']
    $coll.insert_one({
      'title' => title,
      'time' => time,
      'data' => data
    })
  end
end
