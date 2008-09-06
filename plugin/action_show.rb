def action_show()
  page = $storage.get_page($wiki.page)
  snapshot = page.last_snapshot()
  alert = ""
  aptitle = ""
  if($wiki.time != nil)
    snapshot = page.find_snapshot($wiki.time)
    key = rand(100).to_s
    alert = WabisabiConverter.toHTML([
      ["div",{"class"=>"alert"},
        "This page is old version(#{snapshot.time.to_s})",
        ["form",{ "action"=>$wiki.make_link($wiki.page,"update"),
                  "method"=>"post",
                  "name"=>"edit",
                },
          ["input",{"type"=>"hidden",
                    "name"=>"msg",
                    "value"=>snapshot.data,
                   }],
          "You can ",
          ["input",{"type"=>"submit","value"=>"revert"}],
          " To this version.",
        ] + ( EASYPASSWORD ? [
          ["br",{}],
          "(Need insert '#{key}' to this box. ",
          ["input",{"type"=>"text","name"=>"pass"}],
          ["input",{"type"=>"hidden","name"=>"key","value"=>"#{key.crypt("AA")}"}],
          ")",
        ] : [] )
      ]])
    aptitle = " (#{snapshot.time.to_s})"
  end

  if(snapshot == nil)
    print $wiki.cgi.header(
      {"status" => "302 Moved Temporarily",
       "Location" => $wiki.make_link($wiki.page,"edit")});
    return nil
  end

  body = ""
  if(snapshot.cache == nil)
    body = convert(snapshot.data)
    snapshot.update_cache(body)
  else
    body = snapshot.cache
  end

  return :body => (alert + body), :title => ($wiki.page + aptitle)
end

# vim: sw=2 : ts=1000 :
