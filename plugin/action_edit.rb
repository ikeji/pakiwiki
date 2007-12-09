def action_edit()
  snapshot = $storage.get_page($wiki.page).last_snapshot
  old = snapshot.data if snapshot != nil
  return :title => "Edit of #{$wiki.page}",
    :body => WabisabiConverter.toHTML([
       ["form",{ "action"=>$wiki.make_link($wiki.page,"update"),
                 "method"=>"post",
                 "name"=>"edit",
               },
         ["textarea", { "name"=>"msg",
                        "rows"=>"20",
                        "cols"=>"80",
                      },
           "#{old}"
         ],
         ["br",{}],
         ["input",{"type"=>"submit","value"=>"write"}]
       ]])
end
# vim: sw=2 : ts=1000 :
