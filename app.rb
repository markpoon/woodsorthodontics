require "sinatra/base"

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

  get '/' do
    slim :index
  end
end
