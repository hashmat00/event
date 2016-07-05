class TicketsController < ApplicationController
  def index
  	@event = Event.find(params[:event_id])
    @tickets = Ticket.all
    @order_item = current_order.order_items.new
  end
  private
        def set_ticket
          @ticket = Ticket.find(params[:id])
      end  
        def ticket_params
            params.require(:ticket).permit(:price,:name, :fee, :event_id, :active, :quantity, :ticket_description, :show_ticket_description, :sale_channel, :fee, :tickets_start_date, :ticket_end_date, :currency, :country)
        end
    
end
