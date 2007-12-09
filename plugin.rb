
# plugin の仕様
#   引数でWikiオブジェクトのインスタンスを受ける。
#   帰り値はプラグインによる。
#   pluginは1ファイル。
#   prefix_pluginname.rbというファイル名でプラグインフォルダに入れる。
#   中身は prefix_pluginname という名の関数の宣言だけでおっけー。
#
# action plugin
#   prefixは"action_"
#   実行プラグイン
#   { :title => "hoge", :body => "foo bar" } を返すとテンプレートを使いレンダリングされる。
#   nilを返すと、何もしないで終了する。
#
# block plugin
#   prefixは"block_"
#   ブロック要素が変換される。
#   変換後のhtmlをわびさび方式で返す
#   副作用を作らない事
#
# inline plugin
#   prefixは"inline_"
#   インライン要素が変換される。
#   変換後のhtmlをわびさび方式で返す
#   副作用を作らない事
#

require "pathname"

$plugins = {}

class Plugin
  attr_reader :source
  def initialize(file)
    instance_eval( @source = File.read(file) , file ,1)
  end
  def self.load_plugins(folder = (Pathname.new(__FILE__).parent + "plugin"))
    Pathname.glob(folder + "**/*.rb").sort.each do |file|
      begin
        $plugins[file.relative_path_from(folder).to_s.gsub("/","::")[0..-4]] = Plugin.new(file)
      rescue LoadError
      end
    end
  end
  attr_accessor :converter
  def method_missing(name,elements)
    @converter.send(name,elements)
  end
end

# vim: sw=2 : ts=1000 :
