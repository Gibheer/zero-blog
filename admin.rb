class Admin < Sinatra::Base
  set $settings
  enable :sessions
  set :haml, :layout => :admin_layout

  get '/' do
    haml :admin_index
  end
end
