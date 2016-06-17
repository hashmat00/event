class RelationshipsController < ApplicationController
    before_action :authenticate_user!
	def create
    @user = User.find(params[:id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
