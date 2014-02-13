class Controller
  def self.call(session)
    return call_method(session) if respond_to? session.request.method
    Routes::MethodNotAllowed.call(session)
  end

  def self.call_method(session)
    result = send(session.request.method, session)
    return result if result.kind_of?(Class)
    session.options[:renderer]
  end
end
