# coding: UTF-8
require 'pathname'

# Using Template

WIKITITLE = "IKeJI Wiki 2nd"

# Path for this cgi.
# FIXME: Enable it.
#BASEPATH = "/wiki.cgi"

# Storage
# You must select one storage.
STORAGE = TextStorage
#STORAGE = DBStorage
#STORAGE = MongoStorage

# Using TextStorage
ENABLE_CACHE = true
#ENABLE_CACHE = false
# Path for data directory.
DATA_PATH = (Pathname.new(__FILE__).parent+"wiki/").to_s
CACHE_PATH = DATA_PATH

# Using DBStorage
DBPATH = "DBI:SQLite:wiki/wiki.sqlite"

# Using edit
# Use easy password
#EASYPASSWORD = false
EASYPASSWORD = true

# for en/ja plugin
#LANG = "en"
#LANG = "ja"

# vim: sw=2 : ts=1000 :
