class YATMLPerser
  def self.parse(string)
    return self.new(string).parse()
  end

  def initialize(str)
    @str = str.gsub(/(\r?\n|\r)/,"\n")
  end

  def parse()
    return parseYATML()
  end

  #for Tokenizer
  def eos?
    return( (@str.size==0) ? true : false)
  end

  def getChr()
    return @str[0].chr
  end
  def nextChr()
    t = getChr()
    @str=@str[1 .. -1]
    return t
  end
  def getChr2()
    return @str[1].chr
  end
  def getTo(target)
    return @str[0 .. @str.index(target)]
  end
  def nextTo(target)
    t = getTo(target)
    @str = @str[@str.index(target) .. -1]
    return t
  end

  #for Parser
  #
  # YATML  : Block*
  # Block  : BlockHead [YATML] [BlockFoot] | Inline
  # Inline : InlineHead [Inline *] [InlineFoot] | Text
  #
  # method which named *s is return Array

  def parseYATML()
    return Array.new if(eos?)
    while(@str =~ /\A<\/@?([a-zA-Z0-9]*>)/m)
      @str = @str.sub(/\A<\/@?([a-zA-Z0-9]*>(\n)?)?/m,"")
    end
    return Array.new if(eos?)
    return parseBlocks()+parseYATML()
  end

  def parseBlocksInternal()
    #return Array.new if(eos?)
    if(getChr() == "<" && getChr2() == "@")
      el = parseTag()
      start = @str
      el.contents = parseBlocks(el.name)
      el.innerYATML = start[0..(start.size - @str.size-1)]
      @str = @str.sub(/\A<\/@?(#{el.name})?>(\n)?/,"")
      return [el]
    else
      return parseInlines()
    end
  end

  def parseBlocks(blockname = "")
    ret = []
    loop do
      return ret if eos?
      if(@str =~ /\A<\/(@|>|#{blockname}>)/)
        return ret
      else
        @str.sub!(/\A<\//,"")
        ret = ret + parseBlocksInternal()
      end
    end
  end

  def parseInlinesInternal()
    if(@str =~ /^<([a-zA-Z0-9]+) *\/>/)
      el = Element.new(false,$1)
      @str = @str.sub( /^<([a-zA-Z0-9]+) *\/>/, "")
      return [el]
    elsif(getChr() == "<" && getChr2() != "@")
      el = parseTag()
      start = @str
      el.contents = parseInlines()
      el.innerYATML = start[0..(start.size - @str.size-1)] if(start.size - @str.size > 0)
      @str = @str.sub(/\A<\/(#{el.name})?>(\n)?/,"")
      return [el]
    else
      return parseTexts()
    end
  end

  def parseInlines()
    ret = []
    loop do
      return ret if eos?
      if(getChr() == "<" && getChr2() == "@")
        return ret
      elsif(getChr() == "<" && getChr2() == "/")
        return ret
      else
        ret = ret + parseInlinesInternal()
      end
    end
  end

  def parseTexts()
    @str = @str.sub(/\A([^<]*)/m){ $1.sub(/(\n)\z/,"") }
    convWiki()
    @str = @str.sub(/\A([^<]*)/m,"")
    return convWikiElement($1)
  end

  def convWiki()
    @str = @str.sub(/\A([^<]*)/m,"")
    text = $1
    # FIXME:Wiki記法を使うならここに書く
    text.gsub!(/(\n|^)#(.*)(\n|$)/){ "<sumi>#{$2}</sumi>" }
    text.gsub!(/(?:\n|^)(\*+)(.*)(?:\n|$)/)do
      "<@#{"sub" * ($1.size-1)}section>#{$2}</#{"sub" * ($1.size-1)}section>"
    end
    text.gsub!(/\n\n+/,"\n\n")
    text.gsub!(/\n/,"<br></br>")
    @str = text + @str
  end

  def convWikiElement(str)
    # FIXME: 記法はここでも増やす
    if(str =~ /\A(.*?)\[\[(.*?)>(.*?)\]\](.*?)\Z/m)
      match = [$1,$2,$3,$4]
      el = Element.new(false,"link")
      el.contents = [match[1]]
      el.innerYATML = match[1]
      el.attr['page'] = match[2]

      ret = convWikiElement(match[0]) + [el] + convWikiElement(match[3])
      return ret.delete_if{|i| i==""}
    end
    if(str =~ /\A(.*?)\[\[(.*?)\]\](.*?)\Z/m)
      match = [$1,$2,$3]
      el = Element.new(false,"link") do |el|
        el.contents = [match[1]]
        el.innerYATML = match[1]
      end

      ret = convWikiElement(match[0]) + [el] + convWikiElement(match[2])
      return ret.delete_if{|i| i==""}
    end
    if(str =~ /\A(.*?)((http|https|ftp|skype|callto):[A-Za-z0-9:\/?#\[\]@~$&'()*+,;=%._~\-]*)(.*?)\Z/m)
      match = [$1,$2,$4]
      el = Element.new(false,"link")
      el.contents = [match[1]]
      el.innerYATML = match[1]

      ret = convWikiElement(match[0]) + [el] + convWikiElement(match[2])
      return ret.delete_if{|i| i==""}
    end
    pagelist = $storage.list.map{|p|p.page_title}.
      #delete_if{|p| p =~ /^[A-Z][a-z]+([A-Z][a-z]+)+$/}.
      map{|p|Regexp.escape(p)}.sort.reverse.join("|")
    if(str =~ Regexp.new("\\A(.*?)(#{pagelist})(.*?)\\Z",Regexp::MULTILINE))
      match = [$1,$2,$3]
      el = Element.new(false,"autolink") do|el|
        el.contents = [Element.new(false,"link") do|el|
          el.contents = [match[1]]
          el.innerYATML = match[1]
        end]
        el.innerYATML = match[1]
      end
      if(match[1] =~ /^[A-Z][a-z]+([A-Z][a-z]+)+$/)
        el = el.contents[0]
      end

      ret = convWikiElement(match[0]) + [el] + convWikiElement(match[2])
      return ret.delete_if{|i| i==""}
    end
    if(str =~ /\A(.*?)([A-Z][a-z]+([A-Z][a-z]+)+)(.*?)\Z/m)
      match = [$1,$2,$4]
      el = Element.new(false,"link")
      el.contents = [match[1]]
      el.innerYATML = match[1]

      ret = convWikiElement(match[0]) + [el] + convWikiElement(match[2])
      return ret.delete_if{|i| i==""}
    end
    return [str]
  end

  def parseTag()
    if(@str !~ /\A\<(\@?)([a-zA-Z0-9]+) *(( +[a-zA-Z0-9]+\=([a-zA-Z0-9]+|\"[^\"]*\"))*) *\>/)
      @str = @str.sub(/^\</,"")
      return Element.new(false,"")
    end
    @str = @str.sub(/\A\<(\@?)([a-zA-Z0-9]+) *(( +[a-zA-Z0-9]+\=([a-zA-Z0-9]+|\"[^\"]*\"))*) *\>(\n)?/,"")
    el = Element.new(($1=="@"),$2)
    $3.gsub(/([a-zA-Z0-9]+)\=(([a-zA-Z0-9]+)|\"([^\"]*)\")/) do 
      el.attr[$1] = $3?$3:$4
    end
    return el
  end
end

# vim: sw=2 : ts=1000 :
