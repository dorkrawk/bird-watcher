require 'sinatra'
require_relative 'twitter_listener'

module BirdWatcher
  class App < Sinatra::Base
    $stdout.sync = true 
    
    @terms = ["#daveandeileen"]

    @listener = TwitterListener.new
    @listener.listen(@terms)

  end
end