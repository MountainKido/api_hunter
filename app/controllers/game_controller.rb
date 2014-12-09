require 'securerandom'
require 'timeout'
require 'open3'

class GameController < ApplicationController
  PATH = 'tmp/run_me'
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token , :only => [:level_callback]
  
#static page
  def index
    @title = 'Welcome'

    @games = {}
    Score.where(:user_id => current_user.id).each do |score|
      @games[score.level] = score
    end
  end
  def about
    @title = 'About'
  end
  
#game page
  
  def level
    @level = params[:id].to_i
  end
  def level_save
    @level = params[:id].to_i
    if Score::TWITTER_LEVEL.include?(@level)
      is_success , result = file_builder(params[:body] , :twitter)
      score = Score.save_score(@level , current_user , is_success , true , params[:body] , result)
    else
      score = Score.save_score(@level , current_user , false , false , params[:body] , params[:body])
    end
    redirect_to level_show_game_path(score.id)
  end
  def level_show
    @score = Score.where(:id => params[:id]).first
    redirect_to root_path unless @score
    @level = @score.level
    @message = @score.result
    @by_user = User.where(:id => @score.user_id).first
  end
  def level_callback
    Score.find(params[:id]).update_attributes(is_success:params['is_success'].to_i == 1,is_callback:true)
    render text:''
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

    success = false
    if status.success?
      success = stdout_str.length > 20
    end
    
    return [ !!success , status.success? ? stdout_str : stderr_str]
  ensure
    `rm #{@random_name}` if @random_name #clear
  end
  
  def check_status(index)
    session[:checked] ||= {}
    session[:checked][index.to_s] = true
  end
end
