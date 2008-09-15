require "pathname"

REGEX_FILENAME = /([\-a-zA-Z0-9]*)(\.[0-9]*)?\.txt/

class TextStorage < Storage
  def get_page(name)
    return TextPage.new(name,escape(name))
  end

  def list()
    Dir[DATA_PATH + "*.txt"].map do |fname|
      fname =~ REGEX_FILENAME
      $1
    end.uniq.map do |i|
      TextPage.new(unescape(i),i)
    end
  end

  def close()
  end

  def escape(string)
    return string.gsub(/([^A-Za-z0-9])/n){ "-%02X" % $1[0] }
  end

  def unescape(string)
    return string.gsub(/-(..)/) { $1.hex.chr }
  end
end

class TextPage < Page
  def initialize(page_title,escape_name)
    @escape_name = escape_name
    @page_title = page_title
  end

  def page_title
    return @page_title
  end

  def last_snapshot()
    if(File.exist?(DATA_PATH+@escape_name+".txt"))
      return TextSnapshot.new(@escape_name+".txt")
    else
      return nil
    end
  end

  def update_data(data)
    if(File.exist?(DATA_PATH+@escape_name+".txt"))
      time = File.stat(DATA_PATH+@escape_name+".txt").mtime.to_i.to_s
      # TODO: 最終更新が5n分前より最近だったら、バックアップしない的な機能をつける
      File.rename(
                  DATA_PATH+@escape_name+".txt",
                  DATA_PATH+@escape_name+"."+time+".txt")
    end
    File.open(DATA_PATH+@escape_name+".txt","w") do |w|
      w.binmode
      w.write data
    end
    return if !ENABLE_CACHE
    Dir["#{CACHE_PATH}*.cache"].each do |fname|
      File.delete(fname)
    end
  end

  def snapshot_list()
    dir = Pathname.new(DATA_PATH)
    Pathname.glob(dir+@escape_name+"*.txt").map do |file|
      TextSnapshot.new(file.relative_path_from(dir).to_s)
    end
  end
end

class TextSnapshot < Snapshot
  def initialize(fname)
    @fname = fname;
  end

  def data
    File.open(DATA_PATH + @fname,"r") do |r|
      r.binmode
      return r.read
    end
  end

  def time
    if(@fname=~/\.(\d+)@\d+\.txt/)
      return Time.at($1.to_i)
    else
      return File.stat(@fname).mtime
    end
  end

  def cache
    return nil if !ENABLE_CACHE
    if(File.exist?("#{CACHE_PATH}#{@fname}.cache"))
      File.open("#{CACHE_PATH}#{@fname}.cache","r") do |r|
        r.binmode
        return r.read
      end
    else
      return nil
    end
  end

  def update_cache(cache)
    return if !ENABLE_CACHE
    File.open("#{CACHE_PATH}#{@fname}.cache","w") do |w|
      w.binmode
      w.write cache
    end
  end
end

# FIXME: 設定ファイルで選べるようにする。

$storage = TextStorage.new()

# vim: sw=2 : ts=1000 :
