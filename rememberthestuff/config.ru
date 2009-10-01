require 'rubygems'
require 'appengine-rack'
require 'sinatra'

AppEngine::Rack.configure_app(
  :application => 'rememberthestuff', 
  :version => 1)

require 'rememberthestuff'
run Sinatra::Application