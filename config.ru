require 'sinatra'
require 'tweetstream'
require 'sequel'
require 'pg'
require './app'

run BirdWatcher::App