module Routes
  class RouteNotFound
    def self.call(session)
      session.response.status = 404
      session.response.content_type = 'text/html'
      session.response.body = 'This page does not exist!'
      nil
    end
  end
end
