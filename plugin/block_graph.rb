require 'digest/sha1'

def block_graph(element)
  dot = element.innerYATML
  name = Digest::SHA1.hexdigest(dot) + ".png"
  fname = "./plugin/graph/"+name
  uname = $wiki.cgibase + "/plugin/graph/"+name
  if(!File.exist?(fname))
    IO.popen("dot -Nfontname='/usr/local/share/fonts/TrueType/ipag.ttf' -Tpng -o #{fname}","w") do |w|
      w.puts dot
    end
  end
  return ["div",{},["img",{"src"=>uname}]]
end

# vim: sw=2 : ts=1000 :
