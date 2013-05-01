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
  css = "" if $wiki.cgi.user_agent =~ /; PPC;|; Windows CE;|Mobile Safari/ 
  cgi.out({"content-type"=>"text/html","charset"=>"utf-8"}) {
    ERB.new(<<END).result(binding)
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xml:lang="ja" xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta name="google-site-verification" content="nkGGkwjelJ9nwYcrocP-nzECDuGf84NuYVY4D_9NSis" />
    <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Tangerine">
    <%= css %>
    <title><%= title %> -- <%= WIKITITLE %></title>
  </head>
  <body>
    <div id="column-contents">
      <div id="head">
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
      <div id="contents">
<%= body %>
      </div>
    </div>
    <div id="column-side">
      <div id="side_hr">
        <hr />
      </div>
      <div id="side_menu">
<%= menu %>
      </div>
    </div>
    <div id="footer">
      [<a href="<%= $wiki.make_link("MenuBar", "edit") %>">Edit side menu</a>] |
      [<a href="<%= $wiki.make_link($wiki.page, "pagelist") %>">Page list</a>] |
      [<a href="<%= $wiki.make_link($wiki.page, "recentedit") %>">Recent edit</a>] |
      [<a href="<%= $wiki.make_link($wiki.page, "recenteditrss") %>">RSS</a>]
      <div id="copyright">
        Copyright (C) 2001-2007 IKeJI 
      </div>
    </div>
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write("\\<script src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'>\\<\\/script>" );
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("UA-1566138-3");
pageTracker._initData();
pageTracker._trackPageview();
</script>
  </body>
</html>
END
  }
end

# vim: sw=2 : ts=1000 :
