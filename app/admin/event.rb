ActiveAdmin.register Event do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
 permit_params :name, :summary, :description, :address, :city, :zipcode, :state, :country, :created_at, :updated_at, :user_id, :picture, :latitude, :longitude, :start_time, :end_time, :video, :is_active
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end
