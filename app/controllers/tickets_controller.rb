class TicketsController < ApplicationController
  def index
  	@event = Event.find(params[:event_id])
    @tickets = Ticket.all
    @order_item = current_order.order_items.new
  end
end
