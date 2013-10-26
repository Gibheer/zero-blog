class Renderer
  COMPONENT_MATCHER = %r{/?(?<template>[^\.]+)\.(?<type>[^\.]+)\.(?<engine>.+)}
  DEFAULT_TYPE = :default_type

  def self.call(session)
    unless session.options.has_key? :render
      session.response.body = ':render not set!'
      return nil
    end
    to_render = session.options[:render]
    unless templates.has_key? to_render
      session.response.body = 'Template does not exist!'
      return nil
    end
    template = templates[to_render]
    type = get_preferred_type(session, template)
    type = template.first[0] if type == DEFAULT_TYPE
    session.response.body = Tilt.new(template[type]).render(session.options)
    session.response.content_type = type_map[type]
    nil
  end

  # initialize the template cache
  def self.find_templates(path)
    @@templates = {}
    Dir[path + '/**/*'].each do |file|
      next unless File.file?(file)
      parts = file.gsub(path, '').match(COMPONENT_MATCHER)
      @@templates[parts[:template]] ||= {}
      @@templates[parts[:template]].merge!({parts[:type].to_sym => file})
    end
  end

  def self.templates
    find_templates 'templates' unless @@templates
    @@templates
  end

  def self.set_types(types)
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
    @type_map ||= types.invert
  end

  def self.get_preferred_type(session, template)
    session.request.accept.types.each do |type|
      next unless types.has_key? type
      return types[type] if template.has_key? types[type]
      return DEFAULT_TYPE if types[type] == DEFAULT_TYPE
    end
  end
end
