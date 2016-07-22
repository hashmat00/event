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
    redirect_to @cart.total_price > 0 ? @cart.paypal_url(url) : url
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