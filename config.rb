require 'pathname'

# Using Template

WIKITITLE = "PakiWiki Web"

# Path for this cgi.
# FIXME: Enable it.
#BASEPATH = "/wiki.cgi"

# Storage
# You must select one storage.
STORAGE = TextStorage
#STORAGE = DBStorage

# Using TextStorage
ENABLE_CACHE = true
# Path for data directory.
DATA_PATH = (Pathname.new(__FILE__).parent+"wiki/").to_s
CACHE_PATH = DATA_PATH

# Using DBStorage
DBPATH = "DBI:SQLite:wiki/wiki.sqlite"

# Using edit
# Use easy password
EASYPASSWORD = false

# for en/ja plugin
#LANG = "en"
#LANG = "ja"

# vim: sw=2 : ts=1000 :
