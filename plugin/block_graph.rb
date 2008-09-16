DOT_CMD = "/usr/local/bin/dot"
DOT_OPT = "-Nfontname='/usr/local/share/fonts/TrueType/ipag.ttf'"


require "rubygems"
require "rparsec"

eval <<'EOL', TOPLEVEL_BINDING
include RParsec
EOL

class DotParser
  include Parsers
  # lexer
  def delim
    (whitespace| char("\n") | char("\r") | comment_block("/*","*/")).many_ 
  end
  def id
    regexp(/[a-zA-Z_][a-zA-Z0-9_]*/) | regexp(/-?(\.[0-9]+|[0-9]+(\.[0-9]*)?)/) | regexp(/\w+/) |
      (char("\"") >> (not_char(?")|str("\\\"")).many_.fragment << char("\"")).map do |raw|
         raw.gsub("\\\"","\"")
      end
  end

  def edgeop
    string("--") | string("->")
  end

  # parser
  def dot
    stmt_list = stmt = subgraph = attr_stmt = attr_list = a_list = edge_stmt = 
      edgeRHS = node_stmt = node_id = port = compass_pt = nil
#graph		:  	[ strict ] (graph | digraph) [ ID ] '{' stmt_list '}'
    body = delim >> char("{") >> lazy{stmt_list} << char("}")
    head = string("strict ").optional() >> delim >> 
      ( string("digraph") | string("graph") ) >> delim>> id 
    graph = delim >> head >> body << delim << eof
#stmt_list 	: 	[ stmt [ ';' ] [ stmt_list ] ]
    stmt_list = delim >> sequence(lazy{stmt},char(";").optional,lazy{stmt_list}) do |stm,b,arr|
      if(arr == nil)
        if(stm == nil)
          []
        else
          [stm]
        end
      else
        if(stm == nil)
          arr
        else
          arr << stm
        end
      end
    end.optional
#stmt 		: 	node_stmt
#		| 	edge_stmt
#		| 	attr_stmt
#		| 	ID '=' ID
#		| 	subgraph
    eq_stmt = sequence(id,delim >> char("=") << delim,id) do |i,b,i2|
      [i,i2]
    end >> value(nil)
    stmt = delim >> (eq_stmt | lazy{node_stmt} | lazy{edge_stmt} | lazy{attr_stmt} | lazy{subgraph}) << delim
#attr_stmt 	: 	(graph | node | edge) attr_list
    attr_stmt = (string("graph") | string("node") | string("edge") ) >> lazy{attr_list} >> value(nil)
#attr_list 	: 	'[' [ a_list ] ']' [ attr_list ]
    attr_list = delim >> char('[') >> lazy{a_list}.optional << 
                delim << char(']') << delim << lazy{attr_list}.optional
#a_list	 	: 	ID [ '=' ID ] [ ',' ] [ a_list ]
    a_list = delim >> id << delim << (char('=') >> delim >> id ).optional >> 
             delim >> char(',').optional >> lazy{a_list}.optional
#edge_stmt 	: 	(node_id | subgraph) edgeRHS [ attr_list ]
    edge_stmt = sequence((lazy{node_id} | lazy{subgraph}),lazy{edgeRHS}) do|i,arr|
                  arr << i
                end << attr_list.optional
#edgeRHS 	: 	edgeop (node_id | subgraph) [ edgeRHS ]
    edgeRHS = delim >> edgeop >> delim >> sequence( (lazy{node_id} | lazy{subgraph}),delim,lazy{edgeRHS}.optional) do |i,b,arr|
                if(arr == nil)
                  [i]
                else
                  arr << i
                end
              end
#node_stmt 	: 	node_id [ attr_list ]
    node_stmt = lazy{node_id} << attr_list.optional
#node_id 	: 	ID [ port ]
    node_id = id << lazy{port.optional}
#port 		: 	':' ID [ ':' compass_pt ]
#		| 	':' compass_pt
    port = (char(':') >> id << (char(':') >> lazy{compass_pt}).optional) | (char(':') >> lazy{compass_pt})
#subgraph 	: 	[ subgraph [ ID ] ] '{' stmt_list '}'
    subgraph = (string("subgraph") >> delim >> id.optional ).optional >> delim >> char('{') >> stmt_list  << char("}")
#compass_pt 	: 	(n | ne | e | se | s | sw | w | nw)
    compass_pt = (string("n") | string("ne") | string("e") | string("se") | 
                  string("s") | string("sw") | string("w") | string("nw"))

    graph
  end


  def self.parser
    DotParser.new.dot
  end
end

require 'digest/sha1'

def block_graph(element)
  dot = element.innerYATML
  begin 
    links = DotParser.parser.parse(dot).flatten.uniq.sort.map{|i| "\"#{i.gsub("\"","\\\"")}\" [ URL = \"#{ $wiki.make_link(i) }\"]; " }.join()
    dot = dot.sub("{","{#{links}") 
  rescue 
  end
  name = Digest::SHA1.hexdigest(dot)
  fname = "./plugin/graph/"+name + ".png"
  fhname = fname + ".html"
  uname = $wiki.cgibase + "/plugin/graph/"+name + ".png"
  if(!File.exist?(fname) || !File.exist?(fhname))
    IO.popen("#{DOT_CMD} #{DOT_OPT} -Tpng -o #{fname}","w") do |w|
      w.puts dot
    end
    IO.popen("#{DOT_CMD} #{DOT_OPT} -Tcmapx -o #{fhname}","w") do |w|
      w.puts dot
    end
  end
  areas = []
  begin
    File.read(fhname).gsub(/<area([^>]+)\/>/)do 
      tmp = {}
      $1.gsub(/([a-z]+)\=\"([^"]+)\"/){ tmp[$1] = $2  }
      areas << tmp
    end
  rescue
  end
  area = areas.map{|i| ["area",i] }
  
  return ["div",{},["img",{"src"=>uname,"usemap"=>"##{name}"}],
           ["map",{"id"=>name,"name"=>name}] + area]
end
# vim: sw=2 : ts=8 :
