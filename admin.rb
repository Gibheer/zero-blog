class Admin < Sinatra::Base
  set $settings
  use Rack::Session::Pool, :expire_after => 1800
  use Rack::Flash, :accessorize => [:error, :warning, :notice]
  set :haml, :layout => :admin_layout
  register Sinatra::CompassSupport

  get '/' do
    haml :admin_index
  end

  get '/post' do
    @posts = Post.all(:order => [:id.desc], :limit => 15)
    haml :admin_posts
  end

  get '/post/new' do
    @post = Post.new
    haml :admin_post_create
  end

  put '/post' do
    if params[:post].has_key? 'tags'
      tags = params[:post].delete('tags')
    else
      tags = []
    end
    @post = Post.new params[:post]
    @post.set_tags tags
    if @post.save
      flash.notice = 'Post saved'
      redirect "/admin/post/#{@post.id}"
    else
      flash.error = 'Error at saving the post'
      flash[:errors] = @post.errors
      redirect "/admin/post/new"
    end
  end

  get '/post/:id' do
    @post = Post.get(params[:id])
    if @post
      haml :admin_post_change
    else
      flash.warning = "Post with id #{params[:id]} not found!"
      redirect './post'
    end
  end

  post '/post/:id' do
    # read the checkbox value
    if params['post'].has_key?('released')
      params['post']['released'] = true
    else
      params['post']['released'] = false
    end
    # get the post and update it
    @post = Post.get(params[:id])
    if @post
      if params[:post].has_key? 'tags'
        tags = params[:post].delete('tags')
      end
      if @post.update(params[:post])
        @post.set_tags tags
        @post.save
      else
        flash.warning = 'Error at saving the post!'
        flash[:errors] = true
      end
      haml :admin_post_change
    else
      flash.warning = "Post with id #{params[:id]} not found!"
      redirect './post'
    end
  end

  # tags
  get '/tag' do
    @tags = Tag.all(:order => [:name.asc])
    haml :admin_tag_index
  end

  put '/tag/new' do
    @tag = Tag.new(:name => params['tag']['name'])
    if @tag.save
      flash[:notice] = "Tag '#{@tag.name}' created!"
    else
      flash[:warning] = "Tag '#{@tag.name} could not be created! Error was: '#{@tag.errors.first}'"
    end
    redirect '/admin/tag'
  end

  get '/tag/:id' do
    @tag = Tag.first(:id => params[:id])
    haml :admin_tag_edit
  end

  post '/tag/:id' do
    @tag = Tag.first(:id => params[:id])
    @tag.name = params['tag']['name']
    if @tag.save
      flash[:notice] = "Tag saved"
      redirect '/admin/tag'
    else
      flash[:notice] = "Tag could not be saved! Message: '#{@tag.errors.first}'"
      haml :admin_tag_edit
    end
  end

  # login
  get '/login' do
    haml :admin_index_no_login
  end

  post '/login' do
    account = Account.authenticate(params['username'], params['password'])
    if account.nil?
      flash.warning = 'wrong username or password'
      flash[:username] = params['username']
      redirect '/admin'
    else
      flash.notice = 'Login successful'
      session[:id] = account.id
      session[:last_updated] = Time.now
      # redirect to the url set from the #before block
      if session.has_key? :to_path
        redirect "/admin#{session.delete(:to_path)}"
      else
        redirect '/admin/'
      end
    end
  end

  get '/logout' do
    session[:id] = nil
    session[:last_updated] = nil
    flash.notice = 'Logout complete'
    redirect '/'
  end

  get '/stylesheet.css' do
    scss :admin_stylesheet
  end

  helpers do
    def session_read
      if (session.has_key?(:id) && session.has_key?(:last_updated) &&
          Time.now - session[:last_updated] < 1800)
        Account.get(session[:id])
      else
        nil
      end
    end

    def keys_to_sym hash
      new_hash = {}
      hash.each do |k, v|
        new_hash[k.to_sym] = v
      end
      hash = new_hash
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

  before do
    @account = session_read
  end

  before %r{^(?!\/(login|stylesheet\.css)+$)} do
    if @account.nil?
      flash.warning = 'You are not logged in!'
      session[:to_path] = request.path_info
      redirect '/admin/login'
    else
      session[:last_updated] = Time.now
    end
  end
end
