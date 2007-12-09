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

  def update_data(data)
    raise NotImplementedError, 'A subclass must override this method.'
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
end

# vim: sw=2 : ts=1000 :
