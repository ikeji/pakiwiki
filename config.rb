require 'pathname'

# Using Template

WIKITITLE = "PakiWiki Web"

# cgiが置いてある場所までのURLフルパス
# FIXME: 有効にする。
#BASEPATH = "/wiki.cgi"

# Using TextStorage
# データディレクトリまでのパス
DATAPATH = (Pathname.new(__FILE__).parent+"wiki/").to_s

# Using edit
# Use easy password
EASYPASSWORD = false

# vim: sw=2 : ts=1000 :
