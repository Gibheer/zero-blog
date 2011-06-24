$LOAD_PATH << File.expand_path(__FILE__) + '/'
require 'libs'

require 'dm-migrations'

namespace :dm do
  desc 'migrate to the database model'
  task :migrate do
    DataMapper.auto_migrate!
  end

  desc 'upgrade the database to the latest model'
  task :upgrade do
    DataMapper.auto_upgrade!
  end

  desc 'fill the database with dummy data from seeds.rb'
  task :seed do
    require 'seeds'
  end
end

desc 'open a console with all libs loaded and a database connection opened'
task :console do
  sh "irb -rubygems -I#{File.expand_path(File.dirname(__FILE__))} -r libs"
end
