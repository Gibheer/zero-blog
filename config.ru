#!/usr/bin/env rackup
require File.expand_path('../lib/boot.rb', __FILE__)

Renderer.find_templates('templates')
run Application.new(Router, {
  :renderer => Renderer,
  :query => {}
})
