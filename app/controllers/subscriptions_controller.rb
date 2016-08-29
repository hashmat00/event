class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]
  before_action :set_cart, only: [:subscription_create, :sub_pramas]
  before_action :sub_pramas, only: [:subscription_create]

  def index
    @subscriptions = Subscription.all
  end

  def subscription_create
    if params[:subscriptions]
      @subscription = Subscription.new(sub_pramas)  
      if @subscription.save
        @subscription.build_ticket_history(user_id:current_user.id, ticket_id: @subscription.ticket.id, event_id: @subscription.ticket.event.id, quantity: @subscription.quantity).save
        @cart.payment.update(cart_id: nil, subscription_id: @subscription.id, user_id: current_user.id)
        EventMailer.payment_success(current_user, @subscription).deliver_now rescue "Payment Email could not sucessfully sent"
        @cart.destroy
        redirect_to event_path(@event.id)
      end  
    end  
  end

  def notify
    if PayPal::SDK::Core::API::IPN.valid?(request.raw_post)
      logger.info("IPN message: VERIFIED")
      render :text => "VERIFIED"
    else
      logger.info("IPN message: INVALID")
      render :text => "INVALID"
    end
  end  

  private 
    def sub_pramas
      { user_id: current_user.id, payment_id: nil, quantity: @cart.quantity, subscriptionable_id: @cart.ticket.id, subscriptionable_type: "Ticket", unit_price: @cart.unit_price, total_price: @cart.total_price, note: "Payment successfully created", pay_mode: @cart.ticket.pay_mode}
    end
    def set_cart
      @cart = Cart.where(id: params[:cart_id]).first
      @ticket = Ticket.where(id: @cart.ticket.id).first
      @event = Event.where(id: @ticket.event.id).first
    end  
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end
    def subscription_params
      params.fetch(:subscription, {})
    end
end
