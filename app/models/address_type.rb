class AddressType < ActiveRecord::Base
	has_many :contact_details, dependent: :destroy
	scope :active, ->{ where(is_active: true) }
  scope :inactive, ->{ where(is_active: false) }
  after_create :create_contact_details
  
  def create_contact_details
  	User.all.each_with_index do |u|
  		u.contact_details.find_or_create_by(address_type_id: self.id)
  	end
  end	

end
