require 'rubygems' 
require 'sinatra'
require 'dm-core'
require 'haml'
require 'sass'
require 'appengine-apis/users'
require 'appengine-apis/mail'

# Setup DataMapper to use appengine datastore
DataMapper.setup(:default, "appengine://auto")

class List
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :due_at, DateTime

  has n, :items
end

get '/' do
  @title = "Remember the stuff!"
  @lists = List.all
  erb :list
end

get '/logout' do
  redirect AppEngine::Users.create_logout_url('/')
end

def create_list_mail(to, name)
  subject = "Ny oppgave! #{name}"
  body = subject + "\nHilsen OC"
  AppEngine::Mail.send("oc@rynning.no", to, subject, body)
end

post '/' do
  @user = AppEngine::Users.current_user
  redirect AppEngine::Users.create_login_url(request.url) unless @user

  list = List.create(:name => params[:name],
    :due_at => DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i, params[:hour].to_i, params[:min].to_i))
    
  create_list_mail(@user.email, params[:name])
  redirect '/'
end

class Item
  include DataMapper::Resource

  property :id, Serial
  property :list_id, Integer
  property :description, Text
  property :got_at, DateTime
end

get '/:list' do
  @list = List.get(params[:list])
  @needed_items = Item.all(:list_id => @list.id, :got_at => nil)
  @got_items = Item.all(:list_id => @list.id).select {|it| it.got_at != nil }
  erb :items
end

post '/:list' do
  list = List.get(params[:list])
  stuff = Item.create(:list_id => list.id, :description => params[:description])
  redirect "/#{params[:list]}"
end

get '/:list/:item' do
  item = Item.get(params[:item])
  item.got_at = DateTime.now
  item.save
  redirect "/#{params[:list]}"
end

def linkify(url, text)
  %(<a href="#{url}" alt="#{text}">#{text}</a>)
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  alias_method :link_to, :linkify
end


