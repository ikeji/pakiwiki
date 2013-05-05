# coding: UTF-8
def block_quot(element)
  return ["blockquote",{}] + convert_element(element.contents)
end

# vim: sw=2 : ts=1000 :
