require 'rubygems' 
require 'sinatra'
require 'dm-core'
require 'sass'

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

# Reload during dev ;)
class Sinatra::Reloader < Rack::Reloader 
   def safe_load(file, mtime, stderr = $stderr) 
     ::Sinatra::Application.reset!
     stderr.puts "#{self.class}: reseting routes" 
     super 
   end 
end

configure :development do
  use Sinatra::Reloader
end
