class WelcomeController < ApplicationController
    
  def home
    @users = User.all
    @events = Event.all
    redirect_to events_path if user_signed_in?
  end
  
  def about
  end

  def set_auth
	 @auth = session[:omniauth]
  end

end