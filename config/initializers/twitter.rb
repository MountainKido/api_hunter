require 'twitter'

$twitter_api = Twitter::REST::Client.new do |config|
  config.consumer_key        = "LuKzYECpFYtoSCFysGDd2aJrl"
  config.consumer_secret     = "1VOTzlBNBWkMfuBY3kyQ4J1Kmwn5TmxUodbmJCHw8quY0w1mvq"
  config.access_token        = "57506002-DXEbU5nyYj34a4yUSxEzzEGdy3GY3AInk4zTMAMfN"
  config.access_token_secret = "0RvcqQrCQWEZhKH9XLX6T3EnAaGMAGyra02CxRAJ5j3Yx"
end
