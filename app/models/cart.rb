class Cart < ActiveRecord::Base
	belongs_to :cartable, polymorphic: true
	has_one :payment
	validate :sale_time
	validate :validate_quantity
	before_save :set_columns
	scope :active, ->{ where(is_active: true) }
  scope :inactive, ->{ where(is_active: false) }
	scope :paid, ->{ where(pay_mode: "paid") }
  scope :free, ->{ where(pay_mode: "free") }
	scope :donation, ->{ where(pay_mode: "donation") }
	require 'paypal-sdk-adaptivepayments'
	def sale_time
		if !(self.ticket[:tickets_start_date] < Time.now && self.ticket[:ticket_end_date] > Time.now rescue nil) 
			errors.add(:_, "You can not add ticket in your cart due to sale ticket time has been expired")
		end
	end
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
	#   PayPal::SDK.configure(
	#   :mode      => "sandbox",  # Set "live" for production
	#   # :app_id    => "Acr9vp3uNJCFV667nwo6LxrnJRsZ2MBCy-tXpt9LtyD57FYWiI8s9mwDZ75sWPbCRNkNZTkM4HjCZNnq",
	#   :username  => "arvindtransactions_api1.paypal.com",
	#   :password  => "4ZMDKRW8FAVHRCQ6",
	#   :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31Av2-PyzC3LbChH42-IseqVZZoP-G" )
	#   @api = PayPal::SDK::AdaptivePayments.new
	#   @pay = @api.build_pay({
	#   :actionType => "PAY",
	#   :cancelUrl => "http://eventdev.herokuapp.com",
	#   :currencyCode => "USD",
	#   :feesPayer => "SENDER",
	#   :ipnNotificationUrl => "http://paypal.corstiaan.ultrahook.com/purchases/paypal_ipn_notify?purchase_guid=7877",
	#   :receiverList => {
	#     :receiver => [{
	#       :amount => 1.0,
	#       :email => "platfo_1255612361_per@gmail.com" }] },
	#   :returnUrl => "http://eventdev.herokuapp.com" })

	# # Make API call & get response
	# @response = @api.pay(@pay)

	# # Access response
	# if @response.success? && @response.payment_exec_status != "ERROR"
	#   @response.payKey
	#   @api.payment_url(@response)  # Url to complete payment
	# else
	#   @response.error[0].message
	# end
    values = {
      :business =>  'rorfuture-facilitator@gmail.com',
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :invoice => rand.to_s[2..7].to_i,
      # :receiverList => {
		    # :receiver => [{
		    #   :amount => 12.0,	
		    #   :email => "platfo_1255612361_per@gmail.com" }] },
      "amount_1" => self.unit_price,
        "item_name_1" => self.ticket.try(:name) + " ticket for " + self.ticket.event.try(:name),
        "item_number_1" => rand.to_s[2..9].to_i,
        "quantity_1" => self.quantity
    }
  "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end
end