require "cgi"
require "time"

class Wiki
  attr_reader :cmd
  attr_reader :page  # FIXME: 名前をpagenameとかにしつつ、pageオブジェクトを参照できるような、pageを設定する。
  attr_reader :time
  attr_reader :cgi
  attr_reader :cgibase

  def initialize(invoke)
    $wiki = self;
    # FIXME: 設定ファイルを読み込む。
    # FIXME: 設定ファイルからpluginフォルダを読み込むようにする。
    Plugin.load_plugins()

    return unless invoke 

    @cgi = CGI.new()
    path = @cgi.path_info

    @page = "FrontPage"
    @cmd = "show"
    @cgibase = @cgi.script_name
    
    # FIXME:
    @cgibase = @cgi.script_name.gsub(/\/wiki.cgi/,"")

    # pathの解析
    #   wiki.cgi/pagename とか wiki.cgi/pagename/edit とか。
    if(path =~ /^\/([A-Za-z0-9.]+)(@([\dT:+-]+))?\/?$/)
      @page = $1
      @time = Time.iso8601($3) if($3 != nil)
    elsif(path =~ /^\/([A-Za-z0-9.]+)(@([\dT:+-]+))?\/([a-z]+)\/?/)
      @page = $1
      @time = Time.iso8601($3) if($3 != nil)
      @cmd = $4
    end

    ret = exec_plugin("action",@cmd)
    return if ret == nil
    render_page(ret[:title],ret[:body])
  end

  def exec_plugin(type,cmd)
    # FIXME: "::"が含まれる場合について考える。
    name = [type,cmd].join("_")
    # FIXME: pluginがない時にエラーを出したい

    return $plugins[ name ].send(name)
  end
  
  def make_link(page="FrontPage",action="show")
    return "#{cgibase}/" if action == "show" && page == "FrontPage"
    return "#{cgibase}/#{page}/#{action}/" if action != "show"
    return "#{cgibase}/#{page}/"
  end

end

# vim: sw=2 : ts=1000 :
