require 'rubygems' 
require 'sinatra'
require 'dm-core'
require 'haml'
require 'sass'

# Setup DataMapper to use appengine datastore
DataMapper.setup(:default, "appengine://auto")

get '/' do
  @title = "Remember the stuff!"
  erb :index
end

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  def link_to(url, text)
    %(<a href="#{url}" alt="#{text}">#{text}</a>)
  end
end

