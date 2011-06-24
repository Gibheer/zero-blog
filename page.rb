class Blog < Sinatra::Base
  set $settings

  get '/' do
    s = '<p><a href="/admin">Adminpanel</a></p>'
    Post.all(:released => true, :order => [:written.desc]).each do |post|
      s += "Post: #{post.title} von #{post.account.username}<br />"
    end
    s
  end

  get '/404' do
    404
  end

  error 404 do
    'where am i? is somebody here? hello?'
  end

  get '/502' do
    502
  end

  error 502 do
    'oh no, i think i wet myself'
  end
end
