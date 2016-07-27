class AddressType < ActiveRecord::Base
	has_many :contact_details, dependent: :destroy
	scope :active, ->{ where(is_active: true) }
  scope :inactive, ->{ where(is_active: false) }
end
