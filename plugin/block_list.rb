# coding: UTF-8
def block_list(element)
  indent = []
  items = []
  current = []
  element.innerYATML.split(/\r?\n/).each do|line|
    if indent.size != 0
      while line[0 .. (indent.join.size-1)] != indent.join
        indent.pop
        c = items.pop
        if(c.size != 0)
          c[-1] << ["ul",{}] + current
        else
          c << ["li",{},["ul",{}] + current]
        end
        current = c
        break if indent.size == 0
      end
      line = line[indent.join.size .. -1 ]
    end
    if(line =~ /^( +)/)
      items.push current
      current = []
      line.sub!(/^( +)/,"")
      indent.push $1
    end
    current.push( ["li",{}] + convertYatml2Wabisabi(line.gsub("~~","\n").gsub("\n\n","~~")))
  end
  while items.size != 0
    c = items.pop
    if(c.size != 0)
      c[-1] << ["ul",{}] + current
    else
      c << ["li",{},["ul",{}] + current]
    end
    current = c
  end
  return ["ul",{}] + current
end

# vim: sw=2 : ts=1000 :
