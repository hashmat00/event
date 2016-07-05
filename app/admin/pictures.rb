ActiveAdmin.register Picture do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :user_id, :image, :picturable_id, :picturable_type, :is_active, :note
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
	
	 index do
    selectable_column
    id_column
    column :user_id
    column :image
    column :picturable_id
    column :picturable_type
    column :is_active
    column :note
    
    actions
  end

  form do |f|
    f.inputs "Picture Details" do
      f.input :user_id
      f.input :image
      f.input :picturable_id
      f.input :picturable_type
      f.input :is_active
      f.input :note

    end
    f.actions
  end


end
