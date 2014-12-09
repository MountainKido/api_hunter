class Score < ActiveRecord::Base
  LEVEL_COUNT = 6
  TWITTER_LEVEL = [0,1,2]

  def self.save_score(level , current_user , is_success , is_callback , source , result)
    temp = {:user_id => current_user.id , :level => level , :is_success => is_success , :is_callback => is_callback , :source => source , :result => result}

    score = Score.where(:user_id => current_user.id , :level => level).first
    if score
      score.update_attributes(temp)
    else
      score = Score.create(temp)
    end
    return score
  end
  def self.user_score(current_user)
    return ((Score.where(:user_id => current_user.id , :is_success => true).count.to_f / LEVEL_COUNT.to_f) * 100).to_i
  end
end
