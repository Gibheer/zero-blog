class Blog < Sinatra::Base
  set $settings
  # never ever again load the Rack::Session::Pool here
  # or the admin pool get's broken and you get thrown out after every request!
  # do that in the config.ru, if you have to!
  register Sinatra::CompassSupport

  get '/' do
    if params.has_key? 'page'
      @current_page = params['page'].to_i
    else
      @current_page = 1
    end
    @page_count = Post.page_count
    @posts = Post.get_page(@current_page - 1)
    haml :index
  end

  get '/:year/:month/:day/:title.html' do
    @post = Post.find_of_day(
      Time.mktime(params[:year], params[:month], params[:day])
    ).select do |post|
      params[:title] == post.title.gsub(/ /, '_').downcase
    end
    if @post.count > 0
      @post = @post[0]
      haml :post_single
    else
      404
    end
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

  get '/atom.xml' do
    @posts = Post.get_page(0)
    haml :atom, :layout => false
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
    markup = markup.to_sym
    if respond_to? markup
      send markup, content
    else
      content
    end
  end
end
