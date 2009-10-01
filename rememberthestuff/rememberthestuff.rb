require 'rubygems' 
require 'sinatra'
require 'dm-core'

# Setup DataMapper to use appengine datastore
DataMapper.setup(:default, "appengine://auto")

class List
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :due_at, DateTime
end

get '/' do
  @title = "Remember the stuff!"
  @lists = List.all
  erb :list
end

post '/' do
  list = List.create(:name => params[:name],
    :due_at => DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i, params[:hour].to_i, params[:min].to_i))
  redirect '/'
end

def linkify(url, text)
  %(<a href="#{url}" alt="#{text}">#{text}</a>)
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  alias_method :link_to, :linkify
end


