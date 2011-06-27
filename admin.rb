class Admin < Sinatra::Base
  set $settings
  enable :sessions
  use Rack::Flash, :accessorize => [:error, :warning, :notice]
  set :haml, :layout => :admin_layout

  get '/' do
    haml :admin_index
  end

  post '/login' do
    account = Account.authenticate(params['username'], params['password'])
    if account.nil?
      flash.warning = 'wrong username or password'
      redirect '/admin'
    else
      flash.notice = 'Login successful'
      redirect '/admin'
    end
  end

  get '/stylesheet.css' do
    scss :admin_stylesheet
  end
end
