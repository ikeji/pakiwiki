def inline_link(element)
  page = element.attr["page"]
  page= element.innerYATML if !page
  if(page =~ /\A(http|https|ftp|skype|callto):[A-Za-z0-9:\/?#\[\]@~$&'()*+,;=%._^\-]*\Z/m)
    # FIXME: リンク内でタグ使うには?
    return ["a",{"href"=>page,"rel"=>"nofollow","class"=>"outlink"},element.innerYATML]
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

# vim: sw=2 : ts=1000 :
