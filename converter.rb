class Converter

  def method_missing(name,element)
    name = name.to_s
    if($plugins.has_key?(name))
      $plugins[name].converter = self
      return $plugins[name].send(name,element)
    else
      return [element.block ? "div":"span",
        {"class"=>element.name}] +
        convert_element(element.contents);
    end
  end

  def accept(element)
    plugin_name = (element.block ? "block_" : "inline_") + element.name
    return self.send(plugin_name,element)
  end

  def convert_element(elements)
    return elements.map do |el|
      if(el.class == String)
        el
      else
        self.accept(el)
      end
    end
  end

  # FIXME: プラグインを展開できるようにする。
  def block_title(element)
    return ["h1",{}] + convert_element(element.contents)
  end
end

def convert(yatml)
  ast = YATMLPerser.parse(yatml)
  wabisabi = Converter.new.convert_element(ast)
  html = WabisabiConverter.toHTML(wabisabi)
  return html
end

def convertYatml2Wabisabi(yatml)
  ast  = YATMLPerser.parse(yatml)
  Converter.new.convert_element(ast)
end

# vim: sw=2 : ts=1000 :
