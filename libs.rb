# this file loads only the libs needed for using "something"
require 'rubygems'
require 'bundler/setup'
require 'bcrypt'
require 'data_mapper'
require 'sinatra'
require 'settings'

DataMapper::Logger.new($stdout, :debug) if Configuration.environment == :development
DataMapper.setup(:default, Configuration.dbconn)

# load the models
$LOAD_PATH << File.expand_path(File.dirname(__FILE__)) + '/models'
require 'account'
require 'post'

DataMapper.finalize

require 'page'
require 'admin'
