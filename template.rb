# coding: UTF-8

require 'erb'
def render_page(title,body)
  #FIXME: thease valiable to config file
  menu_text = $storage.get_page("MenuBar").last_snapshot
  menu = nil
  if(menu_text != nil)
    if menu_text.cache != nil
      menu = menu_text.cache
    else
      menu = convert(menu_text.data) 
      menu_text.update_cache menu
    end
  end
  css = Dir["style/*.css"].map do |i|
    "<link rel=\"stylesheet\" type=\"text/css\" href=\"#{$wiki.cgibase}/#{i}\" />"
  end.join("\n")
  js = Dir["style/*.js"].map do |i|
    "<script src=\"#{$wiki.cgibase}/#{i}\"></script>"
  end.join("\n")
  cgi.out({"content-type"=>"text/html","charset"=>"utf-8"}) {
    ERB.new(<<END).result(binding)
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xml:lang="ja" xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <%= css %>
    <%= js %>
    <title><%= title %> -- <%= WIKITITLE %></title>
    <meta name="viewport" content="width=device-width,user-scalable=no" />
  </head>
  <body>
    <header>
      <a href="#" class="back-link non-mobhide mobhide">Close</a>
      <a href="#" class="menu-link non-mobhide">Menu</a>
      <a href="#" class="edit-link non-mobhide">Edit</a>
      <h1><%= title %></h1>
    </header>
    <nav class="edit">
      <ul>
        <li><a href="<%= $wiki.make_link() %>">Top</a></li>
        <li><a href="<%= $wiki.make_link($wiki.page,"show") %>">PermanentLink</a></li>
        <li><a href="<%= $wiki.make_link($wiki.page,"edit") %>">Edit</a></li>
        <li><a href="<%= $wiki.make_link($wiki.page,"srcdiff") %>">Diff(src)</a></li>
        <li><a href="<%= $wiki.make_link($wiki.page,"visualdiff") %>">Diff(visual)</a></li>
        <li><a href="<%= $wiki.make_link($wiki.page,"backup") %>">OldVersion</a></li>
        <li><a href="<%= $wiki.make_link($wiki.page,"dump") %>">Dump ast</a></li>
      </ul>
    </nav>
    <article>
<%= body %>
    </article>
    <nav class="menu">
<%= menu %>
    </nav>
    <footer>
      Copyright (C) 2001-2013 IKeJI 
    </footer>
    <script>w()</script>
  </body>
</html>
END
  }
end

# vim: sw=2 : ts=1000 :
