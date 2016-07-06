ActiveAdmin.register User do
  config.filters = false
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :username, :name, :email, :password, :password_confirmation, :is_admin, :image, :about_organizer, :website_url
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
      f.input :is_admin
      f.input :image
      f.input :about_organizer
      f.input :website_url
    end
    f.actions
  end

# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end