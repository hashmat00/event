class Ticket < ActiveRecord::Base
  belongs_to :event
  has_many :order_items

  default_scope { where(active: true) }
  	def pay_type
       self.fee ? "Paid" : "Free"
	end

	def ticket_price
		if (self.pay_mode == "free") || (self.pay_mode == "FREE") || (self.pay_mode == "Free")
			return 0
		elsif (self.pay_mode == "paid") || (self.pay_mode == "PAID") || (self.pay_mode == "Paid")
			return self.price
		elsif (self.pay_mode == "donation") || (self.pay_mode == "DONATION") || (self.pay_mode == "Donation")
			return 0							
		end
	end
end
