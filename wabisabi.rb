
class WabisabiConverter
  def self.toHTML(wabisabi)
    return wabisabi.map do |e|
      if(e.class == String)
        CGI.escapeHTML(e)
      else
        "<" + CGI.escapeHTML(e[0]) + 
          e[1].keys.map do |k|
            " " + CGI.escapeHTML(k) + "=\"" + CGI.escapeHTML(e[1][k]) + "\""
          end.join("") + 
          if(e.size==2 && e[0] != "div") # HACK: Don't close div tag.
            " />" 
          else 
            ">" + toHTML(e[2..-1]) + "</" + CGI.escapeHTML(e[0]) + ">"
          end
      end
    end.join("")
  end
end

# vim: sw=2 : ts=1000 :
