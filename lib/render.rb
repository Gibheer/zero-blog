# defines a render container with some helper functions to keep the templates
# small
class Render
  SLASH = '/'

  def initialize(options)
    @options = options
  end

  def [](key)
    fetch(key)
  end

  def []=(key, value)
    @options[key] = value
  end

  def fetch(key)
    @options[key]
  end

  def has_key?(key)
    @options.has_key?(key)
  end

  def options
    @options
  end

  def link_to(*params)
    query = []
    while params.last.kind_of? Hash
      query.push params.pop
    end
    return path(params) if query.empty?
    path(params) + '?' + query_string(query)
  end

  def path(params)
    SLASH + params.join(SLASH)
  end

  def query_string(query)
    URI.encode_www_form(query.inject(:merge))
  end
end
