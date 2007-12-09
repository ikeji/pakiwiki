def block_section(element)
  return ["h2",{}] + convert_element(element.contents)
end

# vim: sw=2 : ts=1000 :
