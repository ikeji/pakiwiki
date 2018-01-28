# coding: UTF-8
require 'uri'
begin
  require 'mongo'
rescue LoadError
end

class MongoStorage < Storage
  def initialize()
    if (ENV['MONGODB_URI'] != nil)
      @db = Mongo::Client.new(ENV['MONGODB_URI'])
    else
      @db = Mongo::Client.new().db('wikidb')
    end
    @coll = @db[:pages]
  end

  def get_page(name)
    MongoPage.new(@coll, name)
  end

  def list()
    return @coll.distinct('title').map{|title| MongoPage.new(@coll, title) }
  end

  def close()
  end
end

class MongoPage < Page
  def initialize(coll, title)
    @coll = coll
    @title = title
  end
  def page_title
    return @title
  end

  def last_snapshot()
    doc = @coll.find({'title' => @title}, {:sort => {'time'=> -1}}).first
    return nil if doc == nil
    return MongoSnapshot.new(doc)
  end

  def update_data(data)
    @coll.insert_one({
      'title' => @title,
      'time' => Time.now,
      'data' => data
    })
    return if !ENABLE_CACHE
    Dir["#{CACHE_PATH}*.cache"].each do |fname|
      File.delete(fname)
    end
  end

  def snapshot_list()
    return @coll.find({'title' => @title},
                      {:sort => {'time' => -1}}).map do|doc|
      MongoSnapshot.new(doc)
    end
  end
end

class MongoSnapshot < Snapshot
  def initialize(doc)
    @doc = doc
    @fname = escape(doc['title']) + "_" + time().to_i().to_s()
  end

  def data
    return @doc['data']
  end

  def time
    return @doc['time']
  end
  
  def cache
    return nil if !ENABLE_CACHE
    if(File.exist?("#{CACHE_PATH}#{@fname}.cache"))
      File.open("#{CACHE_PATH}#{@fname}.cache","r:UTF-8") do |r|
        return r.read
      end
    else
      return nil
    end
  end

  def update_cache(cache)
    return if !ENABLE_CACHE
    File.open("#{CACHE_PATH}#{@fname}.cache","w:UTF-8") do |w|
      w.write cache
    end
  end

  private

  def escape(string)
    return string.dup.force_encoding("ASCII-8BIT").gsub(/([^A-Za-z0-9])/n){ $1.bytes.map{|b| "-%02X" % b}.join() }
  end

  def unescape(string)
    return string.gsub(/-(..)/) { $1.hex.chr }.dup.force_encoding("UTF-8")
  end
end

# vim: sw=2 : ts=1000 :
