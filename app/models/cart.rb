class Cart < ActiveRecord::Base
	belongs_to :cartable, polymorphic: true
	has_one :payment
	validate :validate_quantity
	before_save :set_columns
	scope :active, ->{ where(is_active: true) }
  scope :inactive, ->{ where(is_active: false) }
	scope :paid, ->{ where(pay_mode: "paid") }
  scope :free, ->{ where(pay_mode: "free") }
	scope :donation, ->{ where(pay_mode: "donation") }

	# Method For validate the quantity, It doesn't allowed quantity of tickets more than available tickets while saving in cart
  def validate_quantity
    if self[:quantity] > self.available_quantity
      errors.add(:_, "You can not add more than #{available_quantity} tickets in your cart")
    end
  end

	def set_columns
		self[:unit_price] = self.cartable.try(:ticket_price)
		self[:total_price] = self[:unit_price] * self[:quantity]
		self[:pay_mode] = self.ticket.pay_mode
	end
	
	def available_quantity
		return self.ticket.available_count.to_i
	end	

	def ticket
		cartable.class.name == "Ticket" ? cartable : nil
 	end

 	def paypal_url(return_url)
    values = {
      :business =>  'rorfuture-facilitator@gmail.com',
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :invoice => rand.to_s[2..7].to_i,
      "amount_1" => self.unit_price,
        "item_name_1" => self.ticket.try(:name) + " ticket for " + self.ticket.event.try(:name),
        "item_number_1" => rand.to_s[2..9].to_i,
        "quantity_1" => self.quantity
    }
  "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end
end