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
    devise_parameter_sanitizer.permit(:sign_up) do |user|
        user.permit(:username, :email, :password, :password_confirmation, :current_password, :username, :email, :password, :password_confirmation, :image, :name, :about_organizer, :website_url, privacy_attributes: [:id, :user_id, :is_email, :is_message, :is_notification, :is_visible])
    end
    devise_parameter_sanitizer.permit(:account_update) do |user|
        user.permit(:username, :email, :password, :password_confirmation, :current_password, :username, :email, :password, :password_confirmation, :image, :name, :about_organizer, :website_url, privacy_attributes: [:id, :user_id, :is_email, :is_message, :is_notification, :is_visible])
    end
  end
end
