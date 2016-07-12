ActiveAdmin.register Video do

permit_params :user_id, :video, :videoable_id, :videoable_type, :is_active, :note, :video_url, 	:video_type
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
    column :video
    column :videoable_id
    column :videoable_type
    column :video_url
    column :video_type
    column :is_active
    column :note
    
    actions
  end

  form do |f|
    f.inputs "Picture Details" do
      f.input :user_id
      f.input :video
      f.input :videoable_id
      f.input :videoable_type
      f.input :video_url
      f.input :video_type
      f.input :is_active
      f.input :note

    end
    f.actions
  end
end
