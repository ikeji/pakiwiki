require "pp"

def action_dump()
  page = $storage.get_page($wiki.page)
  snapshot = page.find_snapshot($wiki.time)

  if(snapshot == nil)
    print $wiki.cgi.header(
      {"status" => "302 Moved Temporarily",
       "Location" => $wiki.make_link($wiki.page,"edit")});
    return nil
  end

  ast = YATMLPerser.parse(snapshot.data)
  wabisabi = Converter.new.convert_element(ast)

  out = [
          ["h2",{},"AST"],
          ["pre",{},
            ast.pretty_inspect
          ],
          ["h2",{},"wabisabi"],
          ["pre",{},
            wabisabi.pretty_inspect
          ]
        ]

  return :body => WabisabiConverter.toHTML(out), :title => $wiki.page;
end

# vim: sw=2 : ts=1000 :
