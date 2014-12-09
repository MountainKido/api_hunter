class ProfileController < ApplicationController
  def index
  end
  def save
    current_user.update_attribute('name' , params[:name])
    redirect_to root_path
  end
end
