class LoginController < ApplicationController
      
  def new
  end

  def create
  user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You have successfully logged in"
      redirect_to root_path
    else
      flash.now[:danger] = "Your email or password do not matched"
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have successfully logout"
    redirect_to login_path
  end
end