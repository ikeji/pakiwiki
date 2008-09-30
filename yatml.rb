#コンバート専用

kcode = $KCODE
$KCODE = 'u'
require "pathname"

require Pathname.new(__FILE__).parent+"storage.rb"
require Pathname.new(__FILE__).parent+"text_storage.rb"
require Pathname.new(__FILE__).parent+"ast.rb"
require Pathname.new(__FILE__).parent+"yatmlperser.rb"
require Pathname.new(__FILE__).parent+"wabisabi.rb"
require Pathname.new(__FILE__).parent+"converter.rb"
require Pathname.new(__FILE__).parent+"wiki.rb"
require Pathname.new(__FILE__).parent+"config.rb"
require Pathname.new(__FILE__).parent+"plugin.rb"

$storage = STORAGE.new

Wiki.new(false)

$KCODE = kcode

