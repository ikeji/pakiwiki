def block_comment(element)
  return ["div",{},
          ["form",{"action"=>$wiki.make_link($wiki.page,"comment"),"method"=>"post"},
           ["div",{},
            "Comment :",
            ["input",{"type"=>"text","name"=>"comm","size"=>"60"}],
            ["input",{"type"=>"submit","value"=>"comment"}],
           ]
          ]
         ] + convert_element(element.contents)
end

# vim: sw=2 : ts=1000 :
