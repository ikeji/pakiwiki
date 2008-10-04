require 'digest/md5'

def action_edit()
  snapshot = $storage.get_page($wiki.page).last_snapshot
  old = snapshot.data if snapshot != nil
  old_digest = Digest::MD5.new.update(old.to_s).to_s
  key = old_digest[0..1].to_i(16)
  return :title => "Edit of #{$wiki.page}",
    :body => WabisabiConverter.toHTML([
       ["form",{ "action"=>$wiki.make_link($wiki.page,"update"),
                 "method"=>"post",
                 "name"=>"edit",
               },
         ["input",{"type"=>"hidden","name"=>"digest","value"=>"#{old_digest}"}],
         ["textarea", { "name"=>"msg",
                        "rows"=>"20",
                        "cols"=>"80",
                      },
           "#{old}"
         ],
         ["textarea", { "name"=>"before_edit",
                        "rows"=>"1",
                        "cols"=>"1",
                        "style"=>"display:none",
                      },
           "#{old}"
         ],
       ] + (EASYPASSWORD ? [
         ["br",{}],
         "Please input '#{key}' to this field.",
         ["input",{"type"=>"text","name"=>"pass"}],
       ] : [] ) + [
         ["br",{}],
         ["input",{"type"=>"submit","value"=>"write"}]
     ]])
end
# vim: sw=2 : ts=1000 :
