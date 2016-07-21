class Payment < ActiveRecord::Base
	belongs_to :subscription
	belongs_to :cart
	belongs_to :user	
end
