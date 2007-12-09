#!/usr/local/bin/ruby

require "cgi"
require "time"

# FIXME: ��ŁA������require�Ƃ��Aplugin��ǂݍ���1�t�@�C�������v���O���������B
require "./config.rb"
require "./plugin.rb"
require "./storage.rb"
require "./text_storage.rb"
require "./ast.rb"
require "./yatmlperser.rb"
require "./wabisabi.rb"
require "./converter.rb"
require "./template.rb"

class Wiki
  attr_reader :cmd
  attr_reader :page  # FIXME: ���O��pagename�Ƃ��ɂ��Apage�I�u�W�F�N�g���Q�Ƃł���悤�ȁApage��ݒ肷��B
  attr_reader :time
  attr_reader :cgi
  attr_reader :cgibase

  def initialize
    $wiki = self;
    # FIXME: �ݒ�t�@�C����ǂݍ��ށB
    # FIXME: �ݒ�t�@�C������plugin�t�H���_��ǂݍ��ނ悤�ɂ���B
    Plugin.load_plugins()

    @cgi = CGI.new()
    path = @cgi.path_info

    @page = "FrontPage"
    @cmd = "show"
    @cgibase = @cgi.script_name
    
    # FIXME:
    @cgibase = @cgi.script_name.gsub(/\/wiki.cgi/,"")

    # path�̉��
    #   wiki.cgi/pagename �Ƃ� wiki.cgi/pagename/edit �Ƃ��B
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
    # FIXME: "::"���܂܂��ꍇ�ɂ��čl����B
    name = [type,cmd].join("_")
    # FIXME: plugin���Ȃ����ɃG���[���o������

    return $plugins[ name ].send(name)
  end
  
  def make_link(page="FrontPage",action="show")
    return "#{cgibase}/" if action == "show" && page == "FrontPage"
    return "#{cgibase}/#{page}/#{action}/" if action != "show"
    return "#{cgibase}/#{page}/"
  end

end

# startup

Wiki.new

# vim: sw=2 : ts=1000 :
