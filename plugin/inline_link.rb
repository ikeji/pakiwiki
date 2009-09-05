require 'iconv'

URL_MATCH = (/\A(http|https|ftp|skype|callto):[A-Za-z0-9:\/?#\[\]@~$&'()*+,;=%._^\-]*\Z/m)

def inline_link(element)
  interwiki = load_inter_wiki()
  interwiki_tag = interwiki.keys.map{|i| Regexp.escape(i) }.join("|")
  page = element.attr["page"]
  page = element.innerYATML if !page
  if(page =~ Regexp.new("\\A(#{interwiki_tag}):(.*)\\Z"))
    target_page = $1
    target_name = $2
    target = Iconv.conv(interwiki[target_page][1],"UTF-8",target_name) rescue target_name
    href = interwiki[target_page][0] + CGI.escape(target)
    return ["a",{"href"=>href,"rel"=>"nofollow","class"=>"outlink"},element.innerYATML]
  end
  if(page =~ URL_MATCH)
    # FIXME: リンク内でタグ使うには?
    href = page
    return ["a",{"href"=>href,"rel"=>"nofollow","class"=>"outlink"},element.innerYATML]
  end
  action = "show"
  action = element.attr["action"].to_s.gsub(/[^A-Za-z0-9.]/,"") if element.attr.has_key?("action")
  # FIXME: リンク内でタグ使うには?
  #return ["a",{"href"=>$wiki.make_link(page,action)}] + convert_element(element.contents)
  if($storage.get_page(page).last_snapshot() != nil)
    return ["a",{"href"=>$wiki.make_link(page,action)},element.innerYATML]
  else
    return ["span",{"style"=>".notfound"},element.innerYATML,["a",{"href"=>$wiki.make_link(page,action)},"?"]]
  end
end

def load_inter_wiki()
  retval = {}
  page = $storage.get_page("InterWiki").last_snapshot()
  return retval if page == nil
  page.data.split("\n").map{|i| i.chomp }.delete_if{|l| l=~/^\*/}.map do|l|
    item = l.split(" ")
    if item.size == 3
      item[1] = "http://ikejima.org/" unless item[1] =~ URL_MATCH
      retval[item[0]] = [item[1],item[2]];
    elsif item.size == 2
      item[1] = "http://ikejima.org/" unless item[1] =~ URL_MATCH
      retval[item[0]] = [item[1],"UTF-8"];
    end
  end
  return retval
end

# vim: sw=2 : ts=1000 :
