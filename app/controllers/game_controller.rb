require 'securerandom'
require 'timeout'
require 'open3'

class GameController < ApplicationController
  PATH = 'tmp/run_me'
  before_action :authenticate_user!
  
#static page
  def index
    @title = 'Welcome'
  end
  def callback_success
    check_status(params[:id])
    render text:''
  end
  def about
    @title = 'About'
  end
  
#game page
  
  def twitter_trends_place #0
  end
  def twitter_trends_place_check
    @title = "Submit"
    @success , @message = file_builder(params[:body] , :twitter)
    check_status(0) if @success
  end
  
  def twitter_draw_kitten #1
  end
  def twitter_draw_kitten_check
    @title = "Submit"
    @success , @message = file_builder(params[:body] , :twitter)
    check_status(1) if @success
  end
  
  def twitter_50_obama #2
  end
  def twitter_50_obama_check
    @title = "Submit"
    @success , @message = file_builder(params[:body] , :twitter)
    check_status(2) if @success
  end
  
  def google_map_london #3
  end
  def google_map_london_check
    @title = "Submit"
  end
  
  def google_map_timezone #4
  end
  def google_map_timezone_check
    @title = "Submit"
  end
  
  def google_chart_timezone #5
  end
  def google_chart_timezone_check
    @title = "Submit"
  end
  
  private
  
  def file_builder(body , content_type)
    return [false , "No content!"] unless body || body.empty?
    return [false , "Direct code injection! , can't use : (`|require|eval|Dir|system|gets|ENV|ARGF)"] if body.index(/(`|require|eval|Dir|system|gets|ENV|ARGF)/)

    Rails.logger.info `pwd`
    Rails.logger.info `ruby -v`
    Rails.logger.info `ls -al tmp/run_me`
    
    init_content = case content_type
    when :twitter
"require 'pp'
require 'twitter'
require 'open-uri'
require 'securerandom'

filename = SecureRandom.hex

$twitter_api = Twitter::REST::Client.new do |config|
  config.consumer_key        = '#{Setting.get('twitter_consumer_key')}'
  config.consumer_secret     = '#{Setting.get('twitter_consumer_secret')}'
  config.access_token        = '#{Setting.get('twitter_access_token')}'
  config.access_token_secret = '#{Setting.get('twitter_access_token_secret')}'
end"
    end
    
    
    @random_name = "#{PATH}/#{SecureRandom.hex}.rb"
    File.open(@random_name , 'w') do |f|
      f.write("
#{init_content}

#{body}
")
    end
    
    stdout_str , stderr_str , status = Open3.capture3("ruby #{@random_name}")
    begin
      Timeout::timeout(5) do
        while !status.exited?
          sleep(0.01)
        end
      end
    rescue
    end
    `kill -9 #{status.pid}` unless status.exited?
    
    return [ status.success? , status.success? ? stdout_str : stderr_str]
  ensure
    `rm #{@random_name}` if @random_name #clear
  end
  
  def check_status(index)
    session[:checked] ||= {}
    session[:checked][index.to_s] = true
  end
end
