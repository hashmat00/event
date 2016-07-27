class RegistrationsController < Devise::RegistrationsController

  def update
  	if resource.update(users_params)
  		super
  	else
  		render 'users/tabs', id: resource.id, tabs: 3
  	end
  end	
  
  protected
  	def users_params
    	 params.require(:user).permit(:username, :name, :email, :password, :password_confirmation, :is_admin, :image, :about_organizer, :website_url, :is_active, :prefix, :first_name, :last_name, :job_title, :company, :blog, :dob, :gender, :google_url, :fb_url, :twitter_url, :linkedin_url, :primary_email, :secondary_email, :paypal_email, privacy_attributes: [:id, :user_id, :is_email, :is_message, :is_notification, :is_visible])
  	end 
    def after_update_path_for(resource)
      if resource.unconfirmed_email
      	sign_out resource
      	"/users/tabs?tab=3&id=#{resource.id}&sign_out=true"
      else
      	"/users/tabs?tab=3&id=#{resource.id}"
      end	
    end
end