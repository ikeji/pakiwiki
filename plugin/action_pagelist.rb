require 'cgi'

def action_pagelist()
  list = $storage.list().sort{|a,b| a.page_title <=> b.page_title }.map do |i|
    <<EOL 
<li>
  <a href="#{$wiki.make_link(i.page_title)}">#{CGI.escapeHTML(i.page_title)}</a>
</li>
EOL
  end.join()

  return :title => "Page List" ,
    :body => "<ul>" + list + "</ul>"
end

# vim: sw=2 : ts=1000 :
