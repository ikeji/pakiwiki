# coding: UTF-8

class WabisabiConverter
  def self.toHTML(wabisabi)
    return wabisabi.map do |e|
      if(e.class == Array)
        "<" + CGI.escapeHTML(e[0]) + 
          if(e.size>=2)
            e[1].keys.map do |k|
              " " + CGI.escapeHTML(k.to_s) + "=\"" + CGI.escapeHTML(e[1][k]) + "\""
            end.join("")
          else
            ""
          end + 
          if(e.size==2 && e[0] != "div") # HACK: Don't close div tag.
            " />" 
          else 
            ">" + toHTML(e[2..-1]) + "</" + CGI.escapeHTML(e[0]) + ">"
          end
      else
        CGI.escapeHTML(e.to_s)
      end
    end.join("")
  end
end

# vim: sw=2 : ts=1000 :
