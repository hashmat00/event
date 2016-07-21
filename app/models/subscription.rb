class Subscription < ActiveRecord::Base
	belongs_to :subscriptionable, polymorphic: true
	has_one :ticket_history, dependent: :destroy
	has_one :payment, dependent: :destroy
	scope :active, ->{ where(is_active: true) }
  scope :inactive, ->{ where(is_active: false) }
	scope :paid, ->{ where(pay_mode: "paid") }
  scope :free, ->{ where(pay_mode: "free") }
	scope :donation, ->{ where(pay_mode: "donation") }

	def ticket
		subscriptionable.class.name == "Ticket" ? subscriptionable : nil
 	end	  
end
