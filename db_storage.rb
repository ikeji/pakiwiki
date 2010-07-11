begin
  require 'dbi'
rescue
end

class DBStorage < Storage
  def initialize()
    $database = DBI.connect(DBPATH)
    $database['AutoCommit'] = true
  end

  def create_table
    $database.do <<EOL
CREATE TABLE wiki(
  id INTEGER PRIMARY KEY,
  title TEXT,
  time INTEGER,
  data TEXT
);
EOL
    $database.do <<EOL
CREATE TABLE cache(
  id INTEGER,
  data TEXT
);
EOL
  end

  def get_page(name)
    DBPage.new(name)
  end

  def list()
    return $database.select_all("SELECT title FROM wiki GROUP BY title").map{|i|DBPage.new i[0]}
  end

  def close()
  end
end

class DBPage < Page
  def initialize(title)
    @title = title
  end
  def page_title
    return @title
  end

  def last_snapshot()
    id = $database.select_one("SELECT id FROM wiki WHERE title = ? ORDER BY time DESC LIMIT 1;", @title)
    return nil if id == nil
    return DBSnapshot.new(id)
  end

  def update_data(data)
    $database.do("INSERT INTO wiki(title,time,data) values(?,?,?);",
      @title, Time.now.to_i, data )
    return if !ENABLE_CACHE
    $database.do("DELETE FROM cache;")
  end

  def snapshot_list()
    return $database.select_all("SELECT id FROM wiki WHERE title = ?",@title).map{|i|DBSnapshot.new i[0]}
  end
end

class DBSnapshot < Snapshot
  def initialize(id)
    @id = id
  end

  def data
    data = $database.select_one("SELECT data FROM wiki WHERE id = ?;", @id)
    return data[0]
  end

  def time
    time = $database.select_one("SELECT time FROM wiki WHERE id = ?;", @id)
    return Time.at(time[0])
  end
  
  def cache
    return nil if !ENABLE_CACHE
    cache = $database.select_one("SELECT data FROM cache WHERE id = ?;", @id)
    return nil if cache == nil
    return cache[0]
  end
  
  def update_cache(cache)
    return if !ENABLE_CACHE
    $database.do("INSERT INTO cache(id, data) values(?,?);", @id, cache)
  end
end

# vim: sw=2 : ts=1000 :
