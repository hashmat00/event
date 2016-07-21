class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  before_action :set_ticket, only: [:create, :update]

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
    @cart = Cart.new
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = @ticket.carts.find_or_create_by(user_id: current_user.id)
    quantity = (params[:cart][:is_cart]).present? ? params[:cart][:quantity] : (@cart.quantity.to_i + params[:cart][:quantity].to_i)
    @cart.update(cart_params.merge(quantity: quantity))
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy
    respond_to do |format|
      format.html { redirect_to carts_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      ticket_id = params[:ticket_id].present? ? params[:ticket_id].to_i : params[:cart][:ticket_id].to_i
      @ticket = Ticket.find(ticket_id)
    end

    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params.require(:cart).permit(:user_id, :cartable_id, :cartable_type, :quantity, :unit_price, :is_active, :true, :note)
    end
end
