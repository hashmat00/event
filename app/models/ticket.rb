class Ticket < ActiveRecord::Base
  has_many :ticket_histories
  belongs_to :event
  has_many :order_items
  has_many :carts, as: :cartable, dependent: :destroy
  scope :active, ->{ where(active: true) }
  scope :inactive, ->{ where(active: false) }
  validates :name, presence: true, length: {minimum: 3, maximum: 60}  
	validates :quantity, presence: true
	validates_numericality_of :quantity
	validates :ticket_description, presence: true, length: {minimum: 3, maximum: 200}  
	validates :tickets_start_date, presence: true
	validates :ticket_end_date, presence: true
	validates :sale_channel, presence: true
	validates :country, presence: true 
	validates :currency, presence: true
	has_many :subscriptions, as: :subscriptionable
	# validates :pay_mode, presence: true
	# validates :price_validate

	def price_validate
		if (self.pay_mode == "free") || (self.pay_mode == "FREE") || (self.pay_mode == "Free")
			unless self.price == nil 
				 errors.add(:price, "price should be nil")
			end	
		elsif (self.pay_mode == "paid") || (self.pay_mode == "PAID") || (self.pay_mode == "Paid")
			unless self.price > 0 
				 errors.add(:price, "price should have a value not either nil nor 0")
			end
		elsif (self.pay_mode == "donation") || (self.pay_mode == "DONATION") || (self.pay_mode == "Donation")
			unless self.price == nil 
				 errors.add(:price, "price should be nil")
			end							
		end
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
		available_count = self.quantity.to_i - self.ticket_histories.active.collect(&:quantity).compact.sum rescue 0
		return available_count > 0 ? available_count : 0
	end	
end
