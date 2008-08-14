require 'erb'
def render_page(title,body)
  #FIXME: thease valiable to config file
  base = $wiki.cgi.script_name.gsub("wiki\.cgi","")
  menu_text = $storage.get_page("MenuBar").last_snapshot
  menu = convert(menu_text.data) if(menu_text != nil)
  css = Dir["style/*.css"].map do |i|
    "<link rel=\"stylesheet\" type=\"text/css\" href=\"#{base}#{i}\" />"
  end.join("\n")
  cgi.out({"type"=>"text/html","charset"=>"utf-8"}) {
    ERB.new(<<END).result(binding)
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xml:lang="ja" xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <%= css %>
    <title><%= title %> -- <%= WIKITITLE %></title>
  </head>
  <body>
    <div id="head">
      <div id="headin">
        <h1><%= title %></h1>
        <div id="head_menu">
          <a href="<%= $wiki.make_link() %>">Top</a>
          <a href="<%= $wiki.make_link($wiki.page,"show") %>">PermanentLink</a>
          <a href="<%= $wiki.make_link($wiki.page,"edit") %>">Edit</a>
          <a href="<%= $wiki.make_link($wiki.page,"srcdiff") %>">Diff(src)</a>
          <a href="<%= $wiki.make_link($wiki.page,"visualdiff") %>">Diff(visual)</a>
          <a href="<%= $wiki.make_link($wiki.page,"backup") %>">OldVersion</a>
          <a href="<%= $wiki.make_link($wiki.page,"dump") %>">Dump ast</a>
        </div>
        <div id="head_hr">
          <hr />
        </div>
      </div>
    </div>
    <div id="contents">
<%= body %>
    </div>
    <div id="side_bar">
      <div id="side_hr">
        <hr />
      </div>
      <div id="side_menu">
<%= menu %>
      </div>
      <div id="footer">
        <div id="copyright">
          Copyright (C) 2001-2007 IKeJI 
        </div>
      </div>
    </div>
  </body>
</html>
END
  }
end

# vim: sw=2 : ts=1000 :
