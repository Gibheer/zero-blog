class Router
  ROUTE_REGEX = %r{\A(/(?<controller>[a-zA-Z]+)\.?(?<extension>[a-zA-Z]+)?(/(?<id>[^/]+)?)?)?\Z}
  # get the controller handling the request
  def self.call(session)
    variables = session.request.path.match(ROUTE_REGEX)
    puts variables.inspect
    return default_route unless variables && variables[:controller]
    session.options[:id] = variables[:id]
    find variables[:controller]
  end

  # the namespace of all routes
  def self.namespace
    @@namespace ||= ::Routes
  end

  # set the namespace to a module or class which holds all controllers
  def self.set_namespace(namespace)
    @@namespace = namespace
  end

  # the default route to take when no path is given
  def self.default_route
    @@default ||= namespace.const_get(:Welcome)
  end

  # set the default route to take when no path is given
  def self.set_default_route(default)
    @@default = default
  end

  # check for the controller name and return 404 when not found
  def self.find(ctrl)
    ctrl = ctrl.capitalize
    return namespace.const_get(ctrl) if namespace.const_defined?(ctrl)
    namespace::RouteNotFound
  end
end
