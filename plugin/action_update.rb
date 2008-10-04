require 'plugin/diff.rb'
require 'digest/md5'

def action_update()
  page = $storage.get_page($wiki.page)
  data = $wiki.cgi.params['msg'].first;
  pass = $wiki.cgi.params['pass'].first;
  digest = $wiki.cgi.params['digest'].first;
  before_edit = $wiki.cgi.params['before_edit'].first;

  raise Exception.new("PASSWORD ERROR") if( EASYPASSWORD && digest[0..1].to_i(16).to_s != key)

  snapshot = $storage.get_page($wiki.page).last_snapshot
  current = snapshot.data if snapshot != nil
  
  if( digest != nil && Digest::MD5.new.update(current) != digest )
    left = Diff::makeDiff(before_edit.split(/\r?\n/),current.split(/\r?\n/))
    right = Diff::makeDiff(before_edit.split(/\r?\n/),data.split(/\r?\n/))
    l = r = 0
    result = []
    loop do
      break if(l >= left.size() && r >= right.size())
      if(l<left.size() && r<right.size())
        if(left[l] == right[r])
          if (left[l].diffmark == Diff::DEL || right[r].diffmark == Diff::DEL)
            # not output
          else
            result.push left[l] 
          end
          l+=1
          r+=1
          next
        end
        if(left[l].diffmark == Diff::ADD)
          result.push left[l]
          l+=1
          next
        end
        if(right[r].diffmark == Diff::ADD)
          result.push right[r]
          r+=1
          next
        end
        raise Exception.new("invalid marge algorighom")
      else
        if(l<left.size() && left[l].diffmark == Diff::ADD)
          result.push left[l]
          l+=1
          next
        end
        if(right[r].diffmark == Diff::ADD)
          result.push right[r]
          r+=1
          next
        end
        raise Exception.new("invalid marge algorighom")
      end
    end
    
    current_digest = Digest::MD5.new.update(current).to_s
    key = current_digest[0..1].to_i(16)
    new_data = result.join("\n")
    return :title => "Edit of #{$wiki.page}",
      :body => WabisabiConverter.toHTML([
        ["h2",{}, "!!!CONFLICTED!!! Update was conflicted."],
        ["form",{ "action"=>$wiki.make_link($wiki.page,"update"),
                  "method"=>"post",
                  "name"=>"edit",
                },
          ["input",{"type"=>"hidden","name"=>"digest","value"=>"#{current_digest}"}],
          ["textarea", { "name"=>"msg",
                         "rows"=>"20",
                         "cols"=>"80",
                       },
                       "#{new_data}"
          ],
          ["textarea", { "name"=>"before_edit",
                         "rows"=>"1",
                         "cols"=>"1",
                         "style"=>"display:none",
                       },
                       "#{current}"
          ],
        ] + (EASYPASSWORD ? [
          ["br",{}],
          "Please input '#{key}' to this field.",
          ["input",{"type"=>"text","name"=>"pass"}],
        ] : [] ) + [
          ["br",{}],
          ["input",{"type"=>"submit","value"=>"write"}]
        ]])
    #return nil
  end

  page.update_data("#{data}")
  print $wiki.cgi.header(
                         {"status" => "302 Found",
                         "Location" => $wiki.make_link($wiki.page)})
                         return nil
end

# vim: sw=2 : ts=1000 :
