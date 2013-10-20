module Routes
  class MethodNotAllowed
    def self.call(session)
      session.response.status = 405
      session.response.content_type = 'text/html'
      session.response.body = 'Method not supported by this resource!'
      nil
    end
  end
end
