def action_pagelist()
  
  list = $storage.list().sort{|a,b| b.last_snapshot.time <=> a.last_snapshot.time }.map do |i|
    <<EOL 
<li>
  <a href="#{$wiki.make_link(i.page_title)}">
    #{i.page_title}
  </a>
</li>
EOL
  end.join()

  return :title => "Page List" ,
    :body => "<ul>" + list + "</ul>"
end

# vim: sw=2 : ts=1000 :
