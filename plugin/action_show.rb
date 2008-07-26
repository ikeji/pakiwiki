def action_show()
  page = $storage.get_page($wiki.page)
  snapshot = page.last_snapshot()
  if($wiki.time != nil)
    for s in page.snapshot_list.sort{|a,b| b.time <=> a.time }
      break if s.time < $wiki.time
      snapshot = s
    end
  end

  if(snapshot == nil)
    print $wiki.cgi.header(
      {"status" => "302 Moved Temporarily",
       "Location" => $wiki.make_link($wiki.page,"edit")});
    return nil
  end

  return :body => convert(snapshot.data), :title => $wiki.page;
end

# vim: sw=2 : ts=1000 :
