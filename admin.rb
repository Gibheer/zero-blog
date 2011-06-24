class Admin < Sinatra::Base
  set $settings

  get '/' do
    'das Adminpanel! und <a href="/">zurueck</a>'
  end
end
