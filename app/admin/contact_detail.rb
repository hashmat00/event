ActiveAdmin.register ContactDetail do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :user_id, :address_type_id, :address1, :address2, :address3, :land_mark, :town, :city, :state, :country, :zipcode, :contact1, :contact2, :landline, :fax, :is_active
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end