class Admin < Sinatra::Base
  set $settings
  enable :sessions
  use Rack::Flash, :accessorize => [:error, :warning, :notice]
  set :haml, :layout => :admin_layout

  before %r{^(?!\/(login)?$)} do
    if session_valid?
      session[:last_updated] = Time.now
      flash.notice = 'session is valid!'
    else
      flash.notice = 'something is wrong'
      redirect '/admin'
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
    session = nil
    flash.notice = 'Logout complete'
    redirect '/' 
  end

  get '/stylesheet.css' do
    scss :admin_stylesheet
  end

  helpers do
    def session_valid?
      if session.has_key?(:id) && session.has_key?(:last_updated)
        account = Account.find(session[:id])
        if account && Time.now - session[:last_updated] < 1800
          @account = account
          true
        else
          false
        end
      else
        false
      end
    end
  end
end
