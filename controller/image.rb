module Routes
  class Images
    def self.call(session)
      file = "images/#{session.request.path.gsub(/images/, '')}"
      return RouteNotFound unless File.exist?(file)
      session.response.body = File.read(file)
      session.response.content_type = 'image/png'
      nil
    end
  end
end
