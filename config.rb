require 'pathname'

# Using Template

WIKITITLE = "PakiWiki Web"

# cgiが置いてある場所までのURLフルパス
# FIXME: 有効にする。
#BASEPATH = "/wiki.cgi"

# Using TextStorage
# データディレクトリまでのパス
DATA_PATH = (Pathname.new(__FILE__).parent+"wiki/").to_s
CACHE_PATH = DATAPATH

# Using edit
# Use easy password
EASYPASSWORD = false

# vim: sw=2 : ts=1000 :
