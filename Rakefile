$LOAD_PATH << File.expand_path(File.dirname(__FILE__)) + '/'
require 'libs'
require 'rake/functions'

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

namespace :import do
  desc 'import all posts from this directory'
  task :jekyll do
    path = ask("Where are the jekyll posts?")
    template = ask("What is the default template? (textile, markdown, ...?)")
    if path.nil?
      puts "no path given! - aborting"
    else
      posts = Dir[path + '/*'].sort
      if posts.empty?
        puts "no posts in this directory"
      else
        import_jekyll posts, template
      end
    end
  end
end
