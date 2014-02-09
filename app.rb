require "sinatra/base"
require "slim"

if settings.development?
  require "sinatra/reloader"
  require 'benchmark'
  require 'pry'
end

class Application < Sinatra::Base
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

# select names that end with .md from the views folder and strip them of their
# endings, turn them each into symbols and pass them through the markdown engine
# then join them into a single page view using the slim layout
  get '/' do
    slim Dir.entries("./views").select{|name| name.match /.md\z/}
    .map{|name| name.sub ".md", ""}.map(&:to_sym)
    .map{|name| markdown name}.join
  end
  get '/css/:name.css' do
    content_type 'text/css', charset: 'utf-8'
    scss(:"/sass/#{params[:name]}")
  end
end
