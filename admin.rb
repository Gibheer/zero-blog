class Admin < Sinatra::Base
  get '/' do
    'das Adminpanel! und <a href="/">zurueck</a>'
  end
end
