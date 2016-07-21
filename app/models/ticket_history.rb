class TicketHistory < ActiveRecord::Base
	belongs_to :subscription
	belongs_to :user
	belongs_to :event
	belongs_to :order
	belongs_to :ticket
	scope :active, ->{ where(is_active: true) }
	scope :inactive, ->{ where(is_active: false) }
end
