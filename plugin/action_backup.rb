require "time"
require "cgi"

def action_backup()
  page = $storage.get_page($wiki.page)
  list = page.sorted_snapshot_list.map do |i|
    ["li",{},
       ["a", { "href" => $wiki.make_link($wiki.page + "@" + i.time.iso8601) },
         i.time.rfc822
       ],
       "-",
       ["a", { "href" => $wiki.make_link($wiki.page + "@" + i.time.iso8601, "srcdiff") },
         "diff"
       ]
    ]
  end

  return :title => CGI.escapeHTML($wiki.page) + " - 過去の編集一覧" ,
    :body => WabisabiConverter.toHTML([["ul",{}] + list])
end

# vim: sw=2 : ts=1000 :
