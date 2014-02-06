require 'tweetstream'
require 'sequel'

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

      db_type = ENV["B_W_DB_TYPE"]
      db_location = ENV["B_W_DB_LOCATION"]
      db_user = ENV["B_W_DB_USER"]
      db_pass = ENV["B_W_DB_PASS"]

      @db = Sequel.connect("#{db_type}://#{db_user}:#{db_pass}@#{db_location}")

      @client = TweetStream::Client.new
    end

    def listen(terms)
      puts "Now listening listening for: #{terms.join}"
      $logger.info "Starting Twitter Listener"
      @client.track(terms) do |status|
        get_image(status)
      end
    end

    def get_image(status)
      if !status.media.empty?
        tweet_photo = status.media.first  # only worry about one photo per tweet
        photo_url = tweet_photo.media_url
        tweet_text = status.text
        tweet_user = status.user
        $logger.info "found image"
        $logger.info "  #{photo_url} by #{tweet_user.screen_name} msg: #{tweet_text}"
        puts "url: #{photo_url}"
        puts "by: #{tweet_user.screen_name} (#{tweet_user.name})"
        puts "tweet: #{tweet_text}"

        store_image(photo_url, tweet_user, tweet_text)
      end
    end

    def store_image(photo_url, tweet_user, tweet_text)
      screen_name = tweet_user.screen_name
      name = tweet_user.name

      @db[:photos].insert(:photo_url => photo_url, :service => "twitter", :username => screen_name, :name => name, :photo_text => tweet_text)
    end
  end

end