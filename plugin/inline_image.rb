# coding: UTF-8

# Image inline tag
# Expect attribute base64 like
# <image src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAAAAAA6fptVAAAACklEQVQIHWP4DwABAQEANl9ngAAAAABJRU5ErkJggg=="></image>
def inline_image(element)
  invalid = ["span",{"class"=>"red"},"invalid image"]
  return invalid unless element.attr.has_key? 'src'
  return invalid unless element.attr['src'].start_with? "data:image/png;base64,"
  return ["img",{"src"=>element.attr['src']}]
end

# vim: sw=2 : ts=1000 :
