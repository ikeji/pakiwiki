require "time"

def action_backup()
  page = $storage.get_page($wiki.page)
  list = page.snapshot_list.sort{|a,b| b.time <=> a.time }.map do |i|
    <<EOL 
<li>
  <a href="#{$wiki.make_link($wiki.page + "@" + i.time.iso8601)}">
    #{i.time.rfc822}
  </a>
 - 
  <a href="#{$wiki.make_link($wiki.page + "@" + i.time.iso8601,"srcdiff")}">
    diff
  </a>
</li>
EOL
  end.join()

  return :title => $wiki.page + " - 過去の編集一覧" ,
    :body => "<ul>" + list + "</ul>"
end

# vim: sw=2 : ts=1000 :
