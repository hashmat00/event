class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:update]
  def update
  	@order.update(order_params)
  	@ticket = TicketHistory.where(order_id: @order.id).first
  end

	def set_order
	   @order = Order.find_by_id(params[:order][:id])
	end      
	def order_params
	    params.require(:order).permit(:first_name, :last_name, :email)
	end
end  