class TicketHistory < ActiveRecord::Base
	belongs_to :user
	belongs_to :event
	belongs_to :order
	belongs_to :ticket
	after_update :update_order
	scope :active, ->{ where(is_active: true) }

	def update_order
		unless self.is_active
			self.order.update(is_active: false)
		end 	
	end 

end
