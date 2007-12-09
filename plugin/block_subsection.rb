def block_subsection(element)
  return ["h3",{}] + convert_element(element.contents)
end

# vim: sw=2 : ts=1000 :
