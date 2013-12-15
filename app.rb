require 'sinatra'
require_relative 'twitter_listener'

module BirdWatcher
  class App < Sinatra::Base
    
    #@terms = ["#daveandeileen"]
    @terms = ["#test"]

    @listener = TwitterListener.new
    @listener.listen(@terms)

    get '/' do
      "Bird Watcher is watching you."
    end
  
  end
end