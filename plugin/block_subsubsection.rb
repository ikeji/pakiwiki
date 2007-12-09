def block_subsubsection(element)
  return ["h4",{}] + convert_element(element.contents)
end

# vim: sw=2 : ts=1000 :
