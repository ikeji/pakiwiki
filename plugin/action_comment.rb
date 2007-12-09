def action_comment()
  page = $storage.get_page($wiki.page)
  data = $wiki.cgi['comm'].first;
  if(data == "")
    # FIXME error message
    raise "hello"
  end
  page.update_data(page.last_snapshot().data.sub(/(<@comment( [^>]*)?>)/){"#{$1}\n#{data}"})
  
  print $wiki.cgi.header(
                        {"status" => "302 Found",
                        "Location" => $wiki.make_link($wiki.page)})
  return nil
end

# vim: sw=2 : ts=1000 :
