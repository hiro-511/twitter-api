require 'json'
require 'yaml'
require 'twitter'

class TwitterClient

  attr_reader = :client

  def initialize()
    constants = YAML.load_file('constant.yml')
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = constants['twitter_consumer_key']
      config.consumer_secret     = constants['twitter_consumer_secret']
      config.access_token        = constants['twitter_access_token']
      config.access_token_secret = constants['twitter_access_token_secret']
    end
  end

  def get_friends_names(user_names)

    slice_size = 100
    friends_names = []

    @client.friend_ids(user_names).each_slice(slice_size).with_index do |slice, i|
      @client.users(slice).each_with_index do |f, j|
        friends_names.push(f.name)
      end
    end
    return friends_names
  end
end

## put twitter user names in array
user_names = ['@fladdict', '@goando']

tweet = TwitterClient.new
all_user_ids = []
user_names.each do |user_name|
    user_ids = tweet.get_friends_names(user_name)
    puts user_ids.length
    all_user_ids.push(user_ids)
end

duplicated_users = all_user_ids.inject(&:&)
if duplicated_users.any?
    puts duplicated_users
else
    puts "no deplicated users"
end
