class TicketHistory < ActiveRecord::Base
	belongs_to :user
	belongs_to :event
	belongs_to :order
	belongs_to :ticket

end
