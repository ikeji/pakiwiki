def block_subsubsubsection(element)
  return ["h5",{}] + convert_element(element.contents)
end

# vim: sw=2 : ts=1000 :
