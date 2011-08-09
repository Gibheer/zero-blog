require 'yaml'

def ask message
  puts message
  STDIN.gets.chomp
end

def import_jekyll files, template
  # all tags used in the posts
  template_tags = {}
  post_tags = {}
  puts "If asked about template tags, please give a replacement."
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

      content = content.gsub /({{.*?}})/ do |m|
        if template_tags.has_key? $1
          template_tags[$1]
        else
          template_tags[$1] = ask("Found tag \"#{$1}\" in post #{data['title']}:")
        end
      end

      post = Post.new(
        :written => data['date'],
        :released => true,
        :account => Account.first(:username => data['author']),
        :markup => template,
        :content => content,
        :title => data['title']
      )
      if post.save
        data['tags'].each do |t|
          if (post_tags.has_key? t)
            post_tags[t] << post
          else
            post_tags[t] = [post]
          end
        end
      else
        puts "post #{post.title} of file #{path} could not be saved!"
      end
    else
      puts "No valid jekyll file #{path}"
      raise ArgumentError, "#{path} is not a jekyll file"
    end
  end
  if post_tags.count > 0
    post_tags.each do |tag_name, posts|
      tag = Tag.new(:name => tag_name)
      tag.posts = posts
      tag.save
    end
  end
end
