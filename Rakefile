$LOAD_PATH << File.expand_path(File.dirname(__FILE__)) + '/'

def require_files
  require 'libs'
  require 'rake/functions'
end

namespace :dm do
  desc 'migrate to the database model'
  task :migrate do
    require_files
    require 'dm-migrations'
    DataMapper.auto_migrate!
  end

  desc 'upgrade the database to the latest model'
  task :upgrade do
    require_files
    require 'dm-migrations'
    DataMapper.auto_upgrade!
  end

  desc 'fill the database with dummy data from seeds.rb'
  task :seed do
    require_files
    require 'seeds'
  end
end

desc 'open a console with all libs loaded and a database connection opened'
task :console do
  sh "irb -rubygems -I#{File.expand_path(File.dirname(__FILE__))} -r libs"
end

namespace :account do
  desc 'create a new account'
  task :create do
    require_files
    require 'highline'
    h = HighLine.new
    acc = Account.new
    acc.username = h.ask('username: ')
    acc.password = h.ask('password: '){|q| q.echo = false }
    acc.password_confirmation = h.ask('password again: '){|q| q.echo = false }
    acc.email = h.ask('email: ')
    acc.role = :admin
    if acc.save
      puts "account saved with id #{acc.id}"
    else
      puts "failure at saving the account: #{acc.errors.first}"
    end
  end
end

namespace :import do
  desc 'import all posts from this directory'
  task :jekyll do
    require_files
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
