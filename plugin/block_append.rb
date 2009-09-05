def block_append(element)
  if element.attr.has_key?("date")
    return ["div", {"class"=>"append"}] +
            convert_element(element.contents) + 
            [["div", {"class"=>"date"}, element.attr["date"].to_s]]
  end
  return ["div", {"class"=>"append"}] +
          convert_element(element.contents)
end

# vim: sw=2 : ts=1000 :
