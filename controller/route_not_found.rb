module Routes
  class RouteNotFound < Controller
    def self.get(session)
      session.options[:render] = 'error/route_not_found'
      session.response.status = 404
    end
  end
end
