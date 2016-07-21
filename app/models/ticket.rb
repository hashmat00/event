class Ticket < ActiveRecord::Base
  has_many :ticket_histories
  belongs_to :event
  has_many :order_items
  has_many :carts, as: :cartable, dependent: :destroy

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

		def available_count
			available_count = self.quantity.to_i - self.ticket_histories.active.collect(&:quantity).compact.sum.count rescue 0
			return available_count > 0 ? available_count : 0
		end	
end
