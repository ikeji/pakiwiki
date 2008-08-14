def action_update()
  page = $storage.get_page($wiki.page)
  data = $wiki.cgi['msg'].first;
  pass = $wiki.cgi['pass'].first;
  key = $wiki.cgi['key'].first;
  raise Exception.new("PASSWORD ERROR") if( EASYPASSWORD && pass.crypt("AA") != key)
  page.update_data("#{data}")
  
  print $wiki.cgi.header(
                        {"status" => "302 Found",
                        "Location" => $wiki.make_link($wiki.page)})
  return nil
end

# vim: sw=2 : ts=1000 :
