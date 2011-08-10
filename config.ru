$LOAD_PATH << File.expand_path(File.dirname(__FILE__)) + '/'
require 'libs'

use Rack::CommonLogger
use Rack::Deflater # compress with gzip
use Rack::Static, :urls => ['/public', '/images']
run Rack::URLMap.new({
  '/' => Blog,
  '/admin' => Admin
})
