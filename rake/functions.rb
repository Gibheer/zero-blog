require 'yaml'

def ask message
  puts message
  STDIN.gets.chomp
end

def import_jekyll files, template
  # from jekyll - lib/jekyll/convertible.rb#26 (08.2011)
  files.each do |path|
    content = File.read(path)
    data = {}
    if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
      content = $POSTMATCH

      begin
        data = YAML.load($1)
      rescue => e
        puts "YAML exception reading #{path}: #{e.message}"
        raise e
      end

      post = Post.new(
        :written => data['date'],
        :released => true,
        :account => Account.first(:username => data['author']),
        :markup => template,
        :content => content,
        :title => data['title']
      )
      puts "post #{post.title} could not be saved! #{post.errors}" unless post.save
    else
      puts "No valid jekyll file #{path}"
      raise ArgumentError, "#{path} is not a jekyll file"
    end
  end
end
