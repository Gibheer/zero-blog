class Blog < Sinatra::Base
  set :logging, true
  get '/' do
    s = '<p><a href="/admin">Adminpanel</a></p>'
    Post.all(:released => true, :order => [:written.desc]).each do |post|
      s += "Post: #{post.title} von #{post.account.username}<br />"
    end
    s
  end
end
