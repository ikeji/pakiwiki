require "plugin/diff.rb"

def action_srcdiff()
  page = $storage.get_page($wiki.page)
  snapshot = page.last_snapshot()
  lastsnapshot = nil
  if($wiki.time != nil)
    for s in page.snapshot_list.sort{|a,b| b.time <=> a.time }
      lastsnapshot = s
      break if s.time < $wiki.time
      snapshot = s
    end
  else
    list = page.snapshot_list
    if(list.size > 1)
      lastsnapshot = list.sort{|a,b| b.time <=> a.time}[1]
    end
  end

  if(snapshot == nil)
    print $wiki.cgi.header(
      {"status" => "302 Moved Temporarily",
       "Location" => $wiki.make_link($wiki.page,"edit")});
    return nil
  end

  if(lastsnapshot == nil)
    return :body => "this is first version", :title => "#{$wiki.page} -- diff"
  end
  
  html = WabisabiConverter.toHTML(
    [["pre",{}] + 
      Diff::makeDiff(
        lastsnapshot.data.split(/\r?\n/),
        snapshot.data.split(/\r?\n/)
      ).map do |i|
        if(i.diffmark == Diff::SAME)
          i + "\n"
        elsif(i.diffmark == Diff::ADD)
          ["span",{"class"=>"diff_add"},i + "\n"]
        else
          ["span",{"class"=>"diff_del"},i + "\n"]
        end
      end
    ])
  
  return :body => html, :title => "Diff of " + $wiki.page;
end

# vim: sw=2 : ts=1000 :
