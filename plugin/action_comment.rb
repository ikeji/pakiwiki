def action_comment()
  page = $storage.get_page($wiki.page)
  data = $wiki.cgi['comm'].first;
  pass = $wiki.cgi['pass'].first;
  key = $wiki.cgi['key'].first;
  if(data == "")
    # FIXME error message
    raise "hello"
  end

  if(EASYPASSWORD)
    if(key == "" || pass == "" )
      key = rand(100).to_s
       #    "Please insert '#{key}' to this box.",
       #    ["input",{"type"=>"text","name"=>"pass"}],
       #    ["input",{"type"=>"hidden","name"=>"key","value"=>"#{key.crypt("AA")}"}],
       return :title=> "Password check!", 
         :body => WabisabiConverter.toHTML([
           ["form",{
                     "action"=>$wiki.make_link($wiki.page,"comment"),
                     "method"=>"post",
                   },
             "Password required.",["br",{}],
             "Please input #{key} to this field.",["br",{}],
             ["input",{"type"=>"text","name"=>"pass"}],
             ["input",{"type"=>"hidden","name"=>"key","value"=>key.crypt("AA")}],
             ["input",{"type"=>"hidden","name"=>"comm","value"=>data}],
             ["input",{"type"=>"submit"}],
           ]
         ])
    end
    raise Exception.new("PASSWORD ERROR") if( EASYPASSWORD && pass.crypt("AA") != key)
  end
  page.update_data(page.last_snapshot().data.sub(/(<@comment( [^>]*)?>)/){"#{$1}\n#{data}"})
  
  print $wiki.cgi.header(
                        {"status" => "302 Found",
                        "Location" => $wiki.make_link($wiki.page)})
  return nil
end

# vim: sw=2 : ts=1000 :
