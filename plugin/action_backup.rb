require "time"
require "cgi"

def action_backup()
  page = $storage.get_page($wiki.page)
  list = page.sorted_snapshot_list.map do |i|
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

  return :title => CGI.escapeHTML($wiki.page) + " - 過去の編集一覧" ,
    :body => "<ul>" + list + "</ul>"
end

# vim: sw=2 : ts=1000 :
