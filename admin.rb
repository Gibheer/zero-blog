class Admin < Sinatra::Base
  set $settings
  use Rack::Session::Pool, :expire_after => 1800
  use Rack::Flash, :accessorize => [:error, :warning, :notice]
  set :haml, :layout => :admin_layout

  before do
    @account = session_read
  end

  before %r{^(?!\/(login)?$)} do
    if @account.nil?
      flash.notice = 'something is wrong'
      redirect '/admin'
    else
      session[:last_updated] = Time.now
      flash.notice = 'session is valid!'
    end
  end

  get '/' do
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
      redirect '/admin/index'
    end
  end

  get '/index' do
    haml :admin_index
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
  end
end
