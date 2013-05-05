# coding: UTF-8
class Element
  attr_accessor("block")
  attr_accessor("name")
  attr_accessor("attr")
  attr_accessor("innerYATML")
  attr_accessor("contents")

  def initialize(block=true,name="",&proc)
    @block = block
    @name = name
    @attr = Hash.new
    @contents = Array.new
    @innerYATML = ""
    proc.call self if proc!=nil
  end

  def to_s()
    return "<" + (@block?"@":"") + @name + " " + (@attr.keys.map{|k| k + "=" + @attr[k] }.join(" ")) + ">" +
      (@block?"\n":"") + @contents.map{|i| i.to_s }.join("") + 
      (@block?"\n":"") + "</" + @name + 
      #"{"+ @innerYATML +"}"+
      ">"
  end
end



# vim: sw=2 : ts=1000 :
