require 'digest/md5'
require 'cgi'

def action_show()
  page = $storage.get_page($wiki.page)
  snapshot = page.last_snapshot()
  alert = ""
  aptitle = ""
  if($wiki.time != nil)
    old = snapshot.data if snapshot != nil
    old_digest = Digest::MD5.new.update(old.to_s).to_s
    key = old_digest[0..1].to_i(16)

    snapshot = page.find_snapshot($wiki.time)
    alert = WabisabiConverter.toHTML([
      ["div",{"class"=>"alert"},
        "This page is old version(#{snapshot.time.to_s})",
        ["form",{ "action"=>$wiki.make_link($wiki.page,"update"),
                  "method"=>"post",
                  "name"=>"edit",
                },
          ["input",{"type"=>"hidden","name"=>"digest","value"=>"#{old_digest}"}],
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
  if(snapshot.cache == nil || $wiki.cgi.params['reload'].first != nil)
    begin
      body = convert(snapshot.data)
      snapshot.update_cache(body)
    rescue NoMemoryError
      body = "An error ouccurred."
    end
  else
    body = snapshot.cache
  end

  return :body => (alert + body), :title => (CGI.escapeHTML($wiki.page) + aptitle)
end

# vim: sw=2 : ts=1000 :
