# coding: UTF-8
$stdout.sync = true

require "./storage.rb"
require "./text_storage.rb"
require "./db_storage.rb"
require "./ast.rb"
require "./yatmlperser.rb"
require "./wabisabi.rb"
require "./converter.rb"
require "./template.rb"
require "./wiki.rb"
require "./config.rb"
require "./plugin.rb"
require 'pp'
require 'cgi'

class FakeCGI < Rack::Request
  def initialize(env)
    super(env)
    @code = '500'
    @header = {}
    @contents = []
    @params = nil
  end
  def out(header)
    @code = '200'
    @header = header
    @contents = [ yield ]
  end
  def header(header)
    out(header) { "" }
  end
  def response()
    if @header.include? 'status'
      @code = @header['status'].to_i().to_s()
      @header.delete 'status'
    end
    return [@code, @header, @contents]
  end
  def params()
    r = Hash.[](super().to_a().map{|p| [p[0], [p[1]]] })
    r.default = [].freeze
    return r
  end
end

$storage = STORAGE.new

run lambda {|env|
  cgi = FakeCGI.new(env)
  Wiki.new(true, cgi)
  cgi.response()
}
use Rack::Static, :urls => ["/style"]
