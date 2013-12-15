require 'tweetstream'

# needed for TweetStream.track because we're not useing Rails here
class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end unless defined? Array.new.extract_options!
end

module BirdWatcher

  class TwitterListener

    def initialize
      TweetStream.configure do |config|
        config.consumer_key       = ENV["TWITTER_CONSUMER_KEY"] 
        config.consumer_secret    = ENV["TWITTER_CONSUMER_SECRET"] 
        config.oauth_token        = ENV["TWITTER_OAUTH_TOKEN"] 
        config.oauth_token_secret = ENV["TWITTER_OAUTH_TOKEN_SECRET"]
        config.auth_method        = :oauth
      end

      @client = TweetStream::Client.new

    end

    def listen(terms)
      puts "Now listening listening for: #{terms.join}"
      @client.track(terms) do |status|
        get_image(status)
      end
    end

    def get_image(status)
      puts "#{status.text}"
    end
  end

end