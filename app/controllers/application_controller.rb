class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception 
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_order
  helper_method :latlong
  helper_method :baseUrl
  helper_method :requestUrl


  def latlong
    {lat: request.location.latitude!=0 ? request.location.latitude : '28.6139', long: request.location.longitude!=0 ? request.location.longitude : '77.2090'}
  end
  def current_order
    if !session[:order_id].nil?
      Order.find(session[:order_id])
    else
      Order.new
    end
  end
    
  def baseUrl
    request.base_url
  end
  def requestUrl
    request.url
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:username, :email, :password, :password_confirmation, :image, :name, :about_organizer, :website_url)}
  end

  
end
