class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  before_action :set_ticket, only: [:create, :update]
  
  def index
    @carts = Cart.all
    @cart = Cart.new
  end

  def new
    @cart = Cart.new
  end

  def create
    @cart = @ticket.carts.find_or_create_by(user_id: current_user.id)
    quantity = (params[:cart][:is_cart]).present? ? params[:cart][:quantity] : (@cart.quantity.to_i + params[:cart][:quantity].to_i)
    @cart.update(cart_params.merge(quantity: quantity))
  end

  def destroy
    @cart.destroy
    respond_to do |format|
      format.html { redirect_to carts_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_ticket
      ticket_id = params[:ticket_id].present? ? params[:ticket_id].to_i : params[:cart][:ticket_id].to_i
      @ticket = Ticket.find(ticket_id)
    end
    def set_cart
      @cart = Cart.find(params[:id])
    end
    def cart_params
      params.require(:cart).permit(:user_id, :cartable_id, :cartable_type, :quantity, :unit_price, :is_active, :true, :note)
    end
end
