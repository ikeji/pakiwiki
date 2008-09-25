def block_def(element)
  items = []
  element.innerYATML.split(/\r?\n/).each do|line|
    if(line =~ /[^:]::([^:]|\Z)/)
      dd = line.split(/::/,2)
      items.push ["dt",{}] + convertYatml2Wabisabi(dd[0])
      items.push ["dd",{}] + (dd==""?[]:convertYatml2Wabisabi(dd[1]+"\n"))
    else
      items[-1].concat convertYatml2Wabisabi(line) if line != ""
      items[-1].push ["br",{}]
    end
  end
  return ["dl",{"class"=>"def"}] + items
end

# vim: sw=2 : ts=1000 :
