$LOAD_PATH << File.expand_path('..', __FILE__)

require 'libraries'
require 'session'
require 'application'
require 'controller'
require 'renderer'
require 'router'

Dir[File.expand_path('../../controller', __FILE__) + '/**'].each do |controller|
  require controller
end
