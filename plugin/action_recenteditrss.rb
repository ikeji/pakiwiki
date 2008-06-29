require 'rss'

def action_recenteditrss()
  rss = RSS::Maker.make("1.0") do |maker|
    maker.channel.about = "http://ikejima.org/FrontPage/recenteditrss"
    maker.channel.title = WIKITITLE
    maker.channel.description = WIKITITLE
    maker.channel.link = "http://ikejima.org/"
 
    $storage.list().sort{|a,b| b.last_snapshot.time <=> a.last_snapshot.time }.map do |i|
      maker.items.new_item do |item|
        item.link = $wiki.make_link(i.page_title)
        item.title = i.page_title
        item.date = i.last_snapshot.time
      end
    end
  end

  return :head => {"type"=>"application/xml","charset"=>"utf-8"},
         :raw => rss.to_s
end

# vim: sw=2 : ts=1000 :
