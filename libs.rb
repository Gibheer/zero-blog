# this file loads only the libs needed for using "something"
require 'rubygems'
require 'bundler/setup'
require 'bcrypt'
require 'data_mapper'
require 'haml'
require 'sass'
require 'compass'
require 'sinatra'
require 'sinatra/support'
require 'rack-flash'

# markups
require 'redcloth'

require 'settings'

# load the models
$LOAD_PATH << File.expand_path(File.dirname(__FILE__)) + '/models'
require 'account'
require 'post'

DataMapper.finalize

require 'page'
require 'admin'
