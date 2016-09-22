class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :set_cart, only: [:create]
  before_action :set_ticket_history, only: [:update]

  def index
    @payments = Payment.all
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = @cart.build_payment(payment_params).save
    url = params[:payment][:url]
    receiver_amount = ((@cart.total_price.to_f*@cart.ticket.event.user.percentage)/100).to_f 
    receiver_email = (@cart.ticket.event.user.paypal_email)
    # redirect_to @cart.total_price > 0 ? @cart.paypal_url(url) : url
    if @cart.total_price > 0
      require 'paypal-sdk-adaptivepayments'
        PayPal::SDK.configure(
          :mode      => "sandbox",  # Set "live" for production
          :app_id    => "APP-80W284485P519543T",
          :username  => "bitterntech-facilitator_api1.gmail.com",
          :password  => "5UFQJ9NRAQY925N5",
          :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31AkYr1SN9OFv0tOdoWXLUJks431Ga" )

        @api = PayPal::SDK::AdaptivePayments.new

        # Build request object
        @pay = @api.build_pay({
          :actionType => "PAY",
          :cancelUrl => request.url,
          :currencyCode => "USD",
          :feesPayer => "SENDER",
          :ipnNotificationUrl => request.url,
          :receiverList => {
            :receiver => [{
              :amount => receiver_amount,
              :email => receiver_email },{
              :amount => @cart.total_price.to_f - receiver_amount,
              :email => "arvindkushwah9@gmail.com" }] },
          :returnUrl => url })

        # Make API call & get response
        @response = @api.pay(@pay)
        # Access response
        if @response.success? && @response.payment_exec_status != "ERROR"
          @response.payKey
          # Transaction.create(starter_id: @current_user.id, listing_id: @listing.id, community_id: @current_community.id, payment_gateway: 'paypal', :unit_tr_key => @response.payKey, listing_author_id: @listing.author_id)
          redirect_to  @api.payment_url(@response)  # Url to complete payment
        else
          flash[:alert] =  @response.error[0].message
          redirect_to :back
        end
      else
        redirect_to url
      end
  end

  def update
    @payment.update(payment_params)
  end

  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_payment
      @payment = Payment.find(params[:id])
    end
    def set_cart
      @cart = Cart.find(params[:payment][:cart_id])
    end 
    def set_ticket_history
      @ticket = TicketHistory.find(params[:payment][:ticket_history_id])
    end  
    def payment_params
     params.require(:payment).permit(:user_id, :subscription_id, :cart_id, :first_name, :last_name, :email, :contact_no, :is_active)
    end
end