def block_ja(element)
  if(!defined?(LANG) || LANG == "ja")
    return ["div",{"class"=>"ja"}] + convert_element(element.contents)
  else
    return ["div",{"class"=>"ja"}]
  end
end
