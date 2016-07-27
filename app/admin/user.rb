ActiveAdmin.register User do
  config.filters = false
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :username, :name, :email, :password, :password_confirmation, :is_admin, :image, :about_organizer, :website_url, :is_active, :prefix, :first_name, :last_name, :job_title, :company, :blog, :dob, :gender, :google_url, :fb_url, :twitter_url, :linkedin_url, :primary_email, :secondary_email, :paypal_email
#
# or
#
  form do |f|
    f.inputs "User Details" do
      f.input :username
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :image
      f.input :about_organizer, as: :text
      f.input :website_url
      f.input :prefix
      f.input :first_name
      f.input :last_name
      f.input :job_title
      f.input :company
      f.input :blog
      f.input :dob, as: :date
      f.input :gender
      f.input :google_url
      f.input :fb_url
      f.input :twitter_url
      f.input :linkedin_url
      f.input :primary_email
      f.input :secondary_email
      f.input :paypal_email
      f.input :is_admin
      f.input :is_active
    
    end
    f.actions
  end

# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end

