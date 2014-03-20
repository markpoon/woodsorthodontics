require "sinatra/base"
require "slim"

if settings.development?
  require "sinatra/reloader"
  require 'benchmark'
  require 'pry'
end
module Sinatra
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == 'admin' and password == 'password'
  end

  module LoginHelper
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Access Denied. Access To This Resource Is Unauthorized.\n"
    end
    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['Margit Woods Login', 'a slightly tipsy wombat']
    end
  end 
  helpers LoginHelper
end

class Application < Sinatra::Base
  helpers Sinatra::LoginHelper
  configure :development do
    register Sinatra::Reloader
    include Benchmark
    Bundler.require(:development)
    get '/binding' do
      Binding.pry
    end
  end

  configure :production do
    Bundler.require(:production)
  end

  get '/scripts/cms.js' do
    coffee :cms
  end

  get '/' do
    slim :index
  end

  get '/md/:filename' do
    markdown params[:filename].intern
  end

  get '/markdown/:filename' do
    Rack::Utils.escape_html File.read("./views/" + params[:filename] + ".md")
  end

  post '/markdown/:filename' do
    protected!
    binding.pry
    File.open("./views/" + params[:filename]) do |file|
      file = params[:content]
    end
  end

  # select names that end with .md from the views folder and strip them of their
  # endings, each into symbols and pass them through the markdown engine
  # then join them into a single page view using the slim layout

  # get '/' do
  #   slim Dir.entries("./views").select{|name| name.match /.md\z/}
  #   .map{|name| name.sub ".md", ""}.map(&:to_sym)
  #   .map{|name| markdown name}.join
  # end

  get '/css/:name.css' do
    content_type 'text/css', charset: 'utf-8'
    scss(:"/sass/#{params[:name]}")
  end
end
