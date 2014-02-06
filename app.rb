require 'sinatra'
require_relative 'twitter_listener'

module BirdWatcher
  class App < Sinatra::Base
    $stdout.sync = true 
    $logger = Logger.new('logs/bird_watcher.log')

    @terms = ["#daveandeileen"]

    @listener = TwitterListener.new
    @listener.listen(@terms)

  end
end