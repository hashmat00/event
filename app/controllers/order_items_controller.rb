class OrderItemsController < ApplicationController
   protect_from_forgery except: [:hook]
  def create
    @order = current_order
      @order_item= current_order.order_items.where(ticket_id:  params[:order_item][:ticket_id].to_i, order_id: current_order.try(:id), event_id: params[:order_item][:event_id].to_i).first
    if @order_item
      @order_item.quantity = @order_item.quantity.to_i + params[:order_item][:quantity].to_i
      already_cart = true
    else
      @order_item = @order.order_items.new(order_item_params)
    end  
    @order_item.user_id = current_user.id
    @order.save
    @order_item.update(total_price: (@order_item.quantity * @order_item.unit_price)) if already_cart
    session[:order_id] = @order.id
  end

  def update
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.update_attributes(order_item_params)
    @order_items = @order.order_items
  end

  def destroy
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy
    @order_items = @order.order_items
  end
  def hook
  end
private
  def order_item_params
    params.require(:order_item).permit(:quantity, :ticket_id, :event_id)
  end
end
