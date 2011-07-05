class Blog < Sinatra::Base
  set $settings
  register Sinatra::CompassSupport
  use Rack::Session::Pool, :expire_after => 1800
  use Rack::Flash, :accessorize => [:error, :warning, :notice]

  get '/' do
    @posts = Post.all(:released => true, :order => [:written.desc])
    haml :index
  end

  get '/post/:id' do
    @post = Post.get_released(params[:id])
    if @post.nil?
      404
    else
      haml :post_single
    end
  end

  get '/post/:id/comment.json' do
    Post.get_released(params[:id]).acknowledged_comments.to_json
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
