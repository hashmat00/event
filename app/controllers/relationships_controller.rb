class RelationshipsController < ApplicationController
  before_action :authenticate_user!
	def create
    @user = User.find(params[:id])
    @resourceRel = current_user.follow(@user)
    if !(@resourceRel.errors.any?)
      Notification.notification(current_user, nil, "follow", @user)
    end
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def unfollow
    @user = User.find(params[:id])
    @resourceRel = current_user.unfollow(@user)
    if !(@resourceRel.errors.any?)
       Notification.notification(current_user, nil, "unfollow", @user)
    end
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
