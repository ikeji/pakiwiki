def block_code(element)
  if element.attr.has_key?("filename")
    return ["div",{"class"=>"code"}, ["div",{"class"=>"filename"}, element.attr["filename"].to_s], ["pre",{},element.innerYATML.to_s]]
  end
  return ["pre",{},element.innerYATML]
end

# vim: sw=2 : ts=1000 :
