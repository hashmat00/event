class WelcomeController < ApplicationController
    
  # def home
  #     @tab = Event.new
  #   @users = User.all
  #   @events = Event.all
  #   if params[:unconfirmed]
  #     flash[:success] = "You have successfully change your email, Please confirm your email"
  #     redirect_to "/users/sign_in"
  #   else
  #     redirect_to events_path if user_signed_in?
  #   end
  # end
  
  def about
  end

  def set_auth
	 @auth = session[:omniauth]
  end

end