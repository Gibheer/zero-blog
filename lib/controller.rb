class Controller
  def self.call(session)
    return call_method(session) if respond_to? session.request.method
    Routes::MethodNotAllowed.call(session)
  end

  def self.call_method(session)
    send(session.request.method, session)
    session.options[:renderer]
  end
end
