class Renderer
  COMPONENT_MATCHER = %r{/?(?<template>[^\.]+)\.(?<type>[^\.]+)\.(?<engine>.+)}
  DEFAULT_TYPE = :default_type

  def self.call(session)
    template = do_checks(session)
    return nil unless template
    type = get_type(session, template)
    session.response.body = render(template, type, session.options)
    session.response.content_type = type_map[type]
    nil
  end

  def self.render(template, type, object)
    layout = templates['layout']
    if layout && layout.has_key?(type)
      return layout[type].render(object) do
        template[type].render(object)
      end
    end
    template[type].render(object)
  end

  def self.do_checks(session)
    unless session.options.has_key? :render
      session.response.body = ':render not set!'
      return nil
    end
    to_render = session.options[:render]
    unless templates.has_key? to_render
      session.response.body = 'Template does not exist!'
      return nil
    end
    return templates[to_render]
  end

  # initialize the template cache
  def self.find_templates(path)
    templates = {}
    Dir[path + '/**/*'].each do |file|
      parts = file.gsub(path, '').match(COMPONENT_MATCHER)
      next unless File.file?(file) && parts
      templates[parts[:template]] ||= {}
      templates[parts[:template]].merge!({parts[:type].to_sym => Tilt.new(file)})
    end
    templates
  end

  def self.templates
    @@templates ||= find_templates 'templates'
  end

  def self.set_types(types)
    @@type_map = types.invert
    @@types = types
  end

  def self.types
    @@types ||= {
      '*/*'                  => DEFAULT_TYPE,
      'text/css'             => :css,
      'text/html'            => :html,
      'application/atom+xml' => :atom
    }
  end

  def self.type_map
    @@type_map ||= types.invert
  end

  def self.get_type(session, template)
    type = get_preferred_type(session.request, template)
    return template.first[0] if type == DEFAULT_TYPE
    type
  end

  def self.get_preferred_type(request, template)
    request.accept.types.each do |type|
      next unless types.has_key? type
      return types[type] if template.has_key? types[type]
      return DEFAULT_TYPE if types[type] == DEFAULT_TYPE
    end
  end
end
