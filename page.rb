class Blog < Sinatra::Base
  set $settings
  register Sinatra::CompassSupport

  get '/' do
    @posts = Post.all(:released => true, :order => [:written.desc])
    haml :index
  end

  get '/stylesheet.css' do
    scss :stylesheet
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

  def link_to display, link
    "<a href=\"${link}\">#{display}</a>"
  end

  def markup content, markup
    markup= markup.to_sym
    if respond_to? markup
      send markup, content
    else
      content
    end
  end
end
