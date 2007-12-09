def action_update()
  page = $storage.get_page($wiki.page)
  data = $wiki.cgi['msg'].first;
  page.update_data("#{data}")
  
  print $wiki.cgi.header(
                        {"status" => "302 Found",
                        "Location" => $wiki.make_link($wiki.page)})
  return nil
end

# vim: sw=2 : ts=1000 :
