class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:usersname, :email, :password, :password_confirmation)}
  end
  
  private
  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end
  # helper_method :current_user
  
  # helper_method :current_user, :user_signed_in?
  
  # def current_user
  #      current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end
  
  
  # def logged_in?
  #   !!current_user
    
  # end
  
  # def require_user
  #   if !user_signed_in?
  #   flash[:danger] = "You need to login to perform such action"
  #   redirect_to users_path
  #   end
  # end
  
end
