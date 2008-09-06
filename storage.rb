class Storage
  def get_page(name)
    raise NotImplementedError, 'A subclass must override this method.'
  end

  def list()
    raise NotImplementedError, 'A subclass must override this method.'
  end

  def close()
  end
end

class Page
  def page_title
    raise NotImplementedError, 'A subclass must override this method.'
  end

  def last_snapshot()
    raise NotImplementedError, 'A subclass must override this method.'
  end

  def find_snapshot(time)
    return last_snapshot if(time == nil)
    snapshot = last_snapshot
    for s in sorted_snapshot_list
      return s if s.time == time
      return s if s.time < time
      snapshot = s
    end
    return snapshot
  end

  def update_data(data)
    raise NotImplementedError, 'A subclass must override this method.'
  end

  # result is must sort by time
  def sorted_snapshot_list()
    snapshot_list().sort{|a,b| b.time <=> a.time }
  end

  def snapshot_list()
    raise NotImplementedError, 'A subclass must override this method.'
  end
end

class Snapshot
  def data
    raise NotImplementedError, 'A subclass must override this method.'
  end

  def time
    raise NotImplementedError, 'A subclass must override this method.'
  end
  
  def cache
    raise NotImplementedError, 'A subclass must override this method.'
  end
  
  def update_cache(cache)
    raise NotImplementedError, 'A subclass must override this method.'
  end
end

# vim: sw=2 : ts=1000 :
