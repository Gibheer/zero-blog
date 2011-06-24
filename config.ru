$LOAD_PATH << File.expand_path(File.dirname(__FILE__)) + '/'
require 'libs'

use Rack::CommonLogger
run Rack::URLMap.new({
  '/' => Blog,
  '/admin' => Admin
})
