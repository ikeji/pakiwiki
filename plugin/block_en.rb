def block_en(element)
  if(!defined?(LANG) || LANG == "en")
    return ["div",{"class"=>"en"}] + convert_element(element.contents)
  else
    return ["div",{"class"=>"en"}]
  end
end
