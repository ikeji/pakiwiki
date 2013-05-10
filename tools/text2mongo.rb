#!/usr/local/bin/ruby
# coding: UTF-8

DATA_PATH = '../wiki/'

require '../storage.rb'
require '../text_storage.rb'
require 'mongo'
require 'uri'
    
fail 'MONGOHQ_URL needed' unless (ENV['MONGOHQ_URL'] != nil)
db = URI.parse(ENV['MONGOHQ_URL'])
db_name = db.path.gsub(/^\//, '')
$db = Mongo::Connection.new(db.host, db.port).db(db_name)
$db.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
$coll = $db['pages']

db = TextStorage.new()

db.list().each do |p|
  title = p.page_title()

  p.snapshot_list().each do |s|
    time = s.time()
    data = s.data()
    p title
    $coll.save({
      'title' => title,
      'time' => time,
      'data' => data
    })
  end
end
