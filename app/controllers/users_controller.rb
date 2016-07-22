class UsersController < ApplicationController
	before_action :set_user, only: [:show]
	before_action :set_ticket, only: [:tickets_history, :ticket_show]
  before_action :authenticate_user!, only: [:tickets_history]
  # layout false, only: [:reports]
	def omniauth
		auth=request.env["omniauth.auth"]
    session[:omniauth] = auth.except('extra')
    user = User.sign_in_from_omniauth(auth)
    sign_in user
    redirect_to root_url, notice: "SIGNED IN"
	end
	
	def reports
		@event = Event.find(params[:event_id])	
	end	

  def index
   	@users = User.all.active.eager_load(:events).where('events.is_active=?', true).references(:events).paginate(page: params[:page], per_page: 6)
    
    respond_to do |format|
     	format.html
     	format.csv { send_data @users.to_csv }
     	format.xls { send_data @users.to_csv(col_sep: "\t") }
    end
  end

  def ticket_show
  	@ticket = current_user.ticket_histories.where(id: params[:id]).first
  end

  def tickets_history
  	if params[:id]
  		@ticket.update(is_active: false)
  		@ticket.subscription.update(is_active: false)
  	end	
  	@tickets = current_user.ticket_histories.eager_load(:event, :ticket, :subscription).references(:event, :ticket, :subscription)	
  	@all_tickets_count = @tickets.try(:active).try(:count)
  	@upcomming_tickets_count = @tickets.where('events.start_time > ?', Time.now).try(:active).try(:count)
  	@saved_tickets_count = @tickets.try(:active).select{|s| current_user.wish_lists_events.map{|m| m == s.event} }.try(:count)
  	@past_tickets_count = @tickets.where('events.end_time < ?', Time.now).try(:active).try(:count)
  	@inactive_tickets_count = @tickets.try(:inactive).try(:count)
  	case params[:tab]
  	when 'all' then @tickets = @tickets
  	when 'upcomming' then @tickets = @tickets.where('events.start_time > ?', Time.now)
  	when 'saved' then @tickets = @tickets.try(:active).select{|s| current_user.wish_lists_events.map{|m| m == s.event} }
  	when 'past' then @tickets = @tickets.where('events.end_time < ?', Time.now)
  	when 'inactive' then @tickets = @tickets.try(:inactive)	
  	else
  		@tickets = @tickets	
  	end
  		@tickets = @tickets.active unless (params[:tab] == 'inactive' || params[:tab] == 'saved')
  end

  def ticket_download
		@ticket = TicketHistory.where(id: params[:ticket_id]).first
		@random_codes = []
		@ticket.quantity.times do |i|
		  @random_code = rand.to_s[2..18].to_i
		  qrcode = RQRCode::QRCode.new("#{@random_code}")
		  png = qrcode.as_png(
      resize_gte_to: false,
      resize_exactly_to: false,
      fill: 'white',
      color: 'black',
      size: 120,
      border_modules: 1,
      module_px_size: 1,	
      file:  Rails.root.join('public','qrcode',"qrcode_#{@random_code}.png")
      )
		  @random_codes << @random_code
		end
		 html = render_to_string(:action => 'ticket_download', :layout => false)
	   pdf = PDFKit.new(html)
	   send_data(pdf.to_pdf)
	end
	
	def show
	  @events = @user.events.paginate(page: params[:page], per_page: 6)
	end
	 
  private   
  def set_user
  	@user = User.find(params[:id])
  end  
  def set_ticket
  	@ticket = current_user.ticket_histories.where(id: params[:id]).first
  end

end