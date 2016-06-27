class CheckoutsController < ApplicationController
  def create
  	# values = {
   #      business: "arvindtransactions_api1.paypal.com",
   #      cmd: "4ZMDKRW8FAVHRCQ6",
   #      upload: 1,
   #      return: "localhost:3000",
   #      invoice: 1,
   #      amount: 10,
   #      item_name: 'Ticket',
   #      item_number: '1',
   #      quantity: '1'
   #  }
   #  redirect_to "#{ENV['paypal_host']}/cgi-bin/webscr?" + values.to_query

   require 'paypal-sdk-adaptivepayments'
PayPal::SDK.configure(
  :mode      => "sandbox",  # Set "live" for production
  :app_id    => "APP-80W284485P519543T",
  :username  => "arvindtransactions_api1.paypal.com",
  :password  => "4ZMDKRW8FAVHRCQ6",
  :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31Av2-PyzC3LbChH42-IseqVZZoP-G" )

@api = PayPal::SDK::AdaptivePayments.new

# Build request object
@pay = @api.build_pay({
  :actionType => "PAY",
  :cancelUrl => "http://localhost:3000/samples/adaptive_payments/pay",
  :currencyCode => "USD",
  :feesPayer => "SENDER",
  :ipnNotificationUrl => "http://localhost:3000/samples/adaptive_payments/ipn_notify",
  :receiverList => {
    :receiver => [{
      :amount => 1.0,
      :email => "platfo_1255612361_per@gmail.com" }] },
  :returnUrl => "http://localhost:3000/samples/adaptive_payments/pay" })

# Make API call & get response
@response = @api.pay(@pay)

# Access response
if @response.success? && @response.payment_exec_status != "ERROR"
  @response.payKey
  @api.payment_url(@response)  # Url to complete payment
else
  @response.error[0].message
end



  end
end
