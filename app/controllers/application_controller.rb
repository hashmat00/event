class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception 
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :latlong
  helper_method :baseUrl
  helper_method :requestUrl

  def latlong
    {lat: request.location.latitude!=0 ? request.location.latitude : '28.6139', long: request.location.longitude!=0 ? request.location.longitude : '77.2090'}
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
