
REGEX_FILENAME = /([\-a-zA-Z]*)(\.[0-9]*)?(\@\d+)?\.txt/

class TextStorage < Storage
  def get_page(name)
    return TextPage.new(name,escape(name))
  end

  def list()
    Dir[DATAPATH + "*.txt"].map do |fname|
      fname =~ REGEX_FILENAME
      $1
    end.uniq.map do |i|
      TextPage.new(unescape(i),i)
    end
  end

  def close()
  end

  def escape(string)
    return string.gsub(/([^A-Za-z])/n){ "-%02X" % $1[0] }
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
    if(File.exist?(DATAPATH+@escape_name+".txt"))
      return TextSnapshot.new(DATAPATH+@escape_name+".txt")
    else
      return nil
    end
  end

  def update_data(data)
    if(File.exist?(DATAPATH+@escape_name+".txt"))
      time = File.stat(DATAPATH+@escape_name+".txt").mtime.to_i.to_s
      # TODO: 最終更新が5n分前より最近だったら、バックアップしない的な機能をつける
      i = 0
      i = i + 1 while(File.exist?(DATAPATH+@escape_name+"@"+i.to_s+".txt"))
      File.rename(
                  DATAPATH+@escape_name+".txt",
                  DATAPATH+@escape_name+"."+time+"@"+i.to_s+".txt")
    end
    File.open(DATAPATH+@escape_name+".txt","w") do |w|
      w.binmode
      w.write data
    end
  end

  def snapshot_list()
    Dir[DATAPATH+@escape_name+"*.txt"].map do |fname|
      TextSnapshot.new(fname)
    end
  end
end

class TextSnapshot < Snapshot
  def initialize(fname)
    @fname = fname;
  end

  def data
    File.open(@fname,"r") do |r|
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
end

# FIXME: 設定ファイルで選べるようにする。

$storage = TextStorage.new()

# vim: sw=2 : ts=1000 :
