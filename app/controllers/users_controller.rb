class UsersController < ApplicationController
	before_action :set_user, only: [:show]
	before_action :set_ticket, only: [:tickets_history, :ticket_show]
    before_action :authenticate_user!, only: [:tickets_history]

	# before_action :require_user, only: [:edit, :update] 
	# before_action :require_same_user, only: [:edit, :update]
	
	
	def omniauth
		auth=request.env["omniauth.auth"]
	    session[:omniauth] = auth.except('extra')
	    user = User.sign_in_from_omniauth(auth)
	    sign_in user
	    redirect_to root_url, notice: "SIGNED IN"
	end
	
    def index
     @users = User.all.paginate(page: params[:page], per_page: 6)
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
    		@ticket.order.update(is_active: false)
    	end	
    	@tickets = current_user.ticket_histories.eager_load(:event, :ticket, :order).references(:event, :ticket, :order)	
    	@all_tickets_count = @tickets.try(:active).try(:count)
    	@upcomming_tickets_count = @tickets.where('events.start_time > ?', Time.now).try(:active).try(:count)
    	@saved_tickets_count = @tickets.select{|s| current_user.wish_lists_events.map{|m| m == s.event} }.try(:count)
    	@past_tickets_count = @tickets.where('events.end_time < ?', Time.now).try(:active).try(:count)
    	case params[:tab]
    	when 'all' then @tickets = @tickets
    	when 'upcomming' then @tickets = @tickets.where('events.start_time > ?', Time.now)
    	when 'saved' then @tickets = @tickets.select{|s| current_user.wish_lists_events.map{|m| m == s.event} }
    	when 'past' then @tickets = @tickets.where('events.end_time < ?', Time.now)
    	else
    		@tickets = @tickets	
    	end
    		@tickets = @tickets.active
    end
	# def new
	# 	@user = User.new
	# end
	
	# def create
	#     @user = User.new(user_params)
	#     if @user.save
	#     flash[:success] = "Your account sucessfully created"
	#     session[:user_id] = @user.id
	#     redirect_to events_path
	#     else
	#         render 'new'
	#     end
	# end
	
	
	# def edit
	   
	# end
	
	
	# def update
	   
	#    if @user.update(user_params)
	#        flash[:success] = "Your account has been updated sucessfully"
	#        redirect_to user_path(@user)
	#    else
	#        render 'edit'
	#    end
	# end
	
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
 #    def require_same_user
 #    	if current_user != @user
    		
 #    		flash[:danger] = "You can only edit/delete your own Profile"
 #    		redirect_to user_path(@user)
 #    	end
 #    end
    	

end