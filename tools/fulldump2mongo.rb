#!/usr/local/bin/ruby
# coding: UTF-8


INPUT_FILE = ARGV[0]

puts "Load from #{INPUT_FILE}"

require 'mongo'
require 'uri'
require 'json'
    
if (ENV['MONGOHQ_URL'] != nil)
  db = URI.parse(ENV['MONGOHQ_URL'])
  db_name = db.path.gsub(/^\//, '')
  $db = Mongo::Connection.new(db.host, db.port).db(db_name)
  $db.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
else
  $db = Mongo::Connection.new().db('wikidb')
end
$coll = $db['pages']

data = JSON.parse(File.read(INPUT_FILE))

data.each_pair do |k,vs|
  title = k
  p title
  vs.each do |v|
    time = Time.at(v['unixtime'])
    data = v['data']
    $coll.save({
      'title' => title,
      'time' => time,
      'data' => data
    })
  end
end
