def block_list(element)
  return ["ul",{}] + element.innerYATML.split(/\r?\n/).map {|i| ["li",{}]+convertYatml2Wabisabi(i) }
end

# vim: sw=2 : ts=1000 :
