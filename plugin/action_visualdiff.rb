require "plugin/diff.rb"
require "cgi"

def action_visualdiff()
  page = $storage.get_page($wiki.page)
  snapshot = page.last_snapshot()
  lastsnapshot = nil
  if($wiki.time != nil)
    for s in page.sorted_snapshot_list
      lastsnapshot = s
      break if s.time < $wiki.time
      snapshot = s
    end
  else
    list = page.sorted_snapshot_list
    if(list.size > 1)
      lastsnapshot = list[1]
    end
  end

  if(snapshot == nil)
    print $wiki.cgi.header(
      {"status" => "302 Moved Temporarily",
       "Location" => $wiki.make_link($wiki.page,"edit")});
    return nil
  end

  if(lastsnapshot == nil)
    return :body => "this is first version", :title => "#{CGI.escapeHTML($wiki.page)} -- diff"
  end
 
  old = convertYatml2Wabisabi(lastsnapshot.data)
  new = convertYatml2Wabisabi(snapshot.data)
 
 
  html = WabisabiConverter.toHTML(mkwabidiff(old,new))
  
  return :body => html, :title => "Diff of " + CGI.escapeHTML($wiki.page);
end

def mkwabidiff(old,new)
  r = Diff::makeDiff(old,new)

  return r.map do|i|
    if(i.diffmark == Diff::ADD)
      addAttr(i,"class","diff_badd")
    elsif(i.diffmark == Diff::DEL)
      addAttr(i,"class","diff_bdel")
    else
      if(i.class == String) 
        i
      else
        [i[0],i[1]] + mkwabidiff(i[2..-1],i.old[2..-1])
      end
    end
  end
end

def addAttr(obj,key,value)
  if(obj.class == String)
    return ["span",{key=>value},obj]
  else
    obj[1][key] = obj[1].has_key?(key) ? obj[1][key] + value : value
    return obj
  end
end

# vim: sw=2 : ts=1000 :
