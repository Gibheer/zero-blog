$LOAD_PATH << File.expand_path('..', __FILE__)

require 'libraries'
require 'session'
require 'application'
require 'controller'
require 'renderer'
require 'render'
require 'router'

config = YAML.load_file(File.expand_path('../../config.yml', __FILE__))
DB = Sequel.connect(config[:db])

Dir[File.expand_path('../../controller', __FILE__) + '/**'].each do |controller|
  require controller
end
