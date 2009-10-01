require 'rubygems' 
require 'sinatra'
require 'dm-core'

get '/' do
  @title = "Remember the stuff!"
  erb :index
end

get '/style.css' do
  ""
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  def link_to(url, text)
    %(<a href="#{url}" alt="#{text}">#{text}</a>)
  end
end
