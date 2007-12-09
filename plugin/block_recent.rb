def block_recent(element)
  list = $storage.list().sort{|a,b| b.last_snapshot.time <=> a.last_snapshot.time }.map do |i|
    ["li",{},
      ["a",{"href"=>$wiki.make_link(i.page_title)},
        i.page_title
      ]
    ]
  end
  return ["div",{}] + convert_element(element.contents) + ([["ul",{}] + list[0..20]])
end
