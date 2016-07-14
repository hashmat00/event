class EventsController < ApplicationController

    before_action :set_event, only: [:edit, :update, :show, :like, :destroy, :contact_email, :add_wishlist]
    # before_action :require_same_user, only: [:edit, :destory, :update]    
    before_action :authenticate_user!, only: [:edit, :update, :destroy, :like]

    
    
  # def index  
  #   @event_slider = Event.all
  #   if params[:category].present?  
  #     @categories = Category.find(params[:category])
  #     @events = @categories.events.where("address LIKE? ", "%#{params[:search]}%" ).near(params[:search], params[:distance], :order => 'address')
  #     elsif params[:search]
  #       @events = Event.where("address LIKE? ", "%#{params[:search]}%" )
  #     elsif params[:distance]
  #       city =  Rails.env == 'development' ? 'Delhi' : request.location.city
  #       @events = Event.near(city, params[:distance], :order => :address) 
  #     elsif params[:start_date] && params[:start_date]
  #       @events =Event.where("created_at >= :start_date AND created_at <= :end_date", {start_date: params[:start_date].to_time, end_date: params[:end_date].to_time})
  #     else 
  #       @events = Event.all
  #     end
  #       @events = @events.paginate(page: params[:page], per_page: 6)
        
  #   end
     
    
    def index
      if params[:lat].present? && params[:long].present?
      @temp_event = Event.new(latitude: params[:lat], longitude: params[:long])
      else
      @temp_event = Event.new(latitude: latlong[:lat], longitude: latlong[:long])  
      end
      
      @events = @temp_event.nearbys(params[:range].present? ? params[:range].to_i : 100, :order => "distance",:units => :km).active   
      @events = Event.all.active if !(@events)
      @events = @events.active.eager_load(:pictures,:videos,:tickets).references(:pictures,:videos,:tickets)
      @events_pictures = @events.sort{|m| m.pictures.count }
      @events_videos = @events.sort{|m| m.videos.count }
      @events = @events
    end

    def tabs
      if params[:single]
        @event = Event.where(id: params[:event_id]).first
      else  
        if params[:lat].present? && params[:long].present?
        @temp_event = Event.new(latitude: params[:lat], longitude: params[:long])
        else
        @temp_event = Event.new(latitude: latlong[:lat], longitude: latlong[:long])  
        end        
        @events = @temp_event.nearbys(params[:range].present? ? params[:range].to_i : 100, :order => "distance",:units => :km).active   
        @events = Event.all.active if !(@events)
        @events = @events.active.eager_load(:pictures,:videos,:tickets).references(:pictures,:videos,:tickets)
        @events_pictures = @events.sort{|m| m.pictures.count }
        @events_videos = @events.sort{|m| m.videos.count }
        @events = @events
      end  
    end

    def add_wishlist
      @wish_list = @event.wish_lists.where(user_id:current_user.id).first
      if @wish_list
       @wish_list = @wish_list.destroy
       @wish_list = false
      else
       @wish_list = @event.wish_lists.create(user_id:current_user.id)
       @wish_list = true
      end  
    end  
    def new
        @event = Event.new
    end
    
    def create
       @event = Event.new(event_params)
       @event.user = current_user
       if @event.save
        User.all.each do |user|
          Notification.create(recipient: user , user: current_user, body: "#{current_user.name } has created event #{@event.name} ", notificable: @event)
        end
        flash[:success] = "You have successfully created the Event"
        redirect_to events_path
        else
            render 'new'
        end
    end
    
    
    def show
        # @events = Event.all.sort_by{|likes| likes.thumbs_up_total}.reverse
    @tickets = Ticket.all
    @order_item = current_order.order_items.new
    if params[:response]
      order_item = OrderItem.where(id: params[:order_item_id].to_i).first
      if order_item
        user = User.where(id: params[:user_id].to_i).first
        order_item.order.update(order_status_id: 2, status: true, purchased_at: Time.now, user_id: user.try(:id), subtotal: order_item.event.is_paid ? order_item.total_price : 0)
        EventMailer.payment_success(user, order_item, order_item.try(:order)).deliver_now rescue "OPPS Mail can not send"
        TicketHistory.new(:user_id => current_user.id, :ticket_id => order_item.ticket.id, :order_id => order_item.order.id, :event_id => order_item.event.id, :quantity => order_item.quantity).save
        @order = current_order
        @order_item = @order.order_items.where(id: order_item.try(:id)).first
        @order_item.destroy
        @order_items = @order.order_items
        if @event.is_paid
          flash[:success] = "Your Payment has been done successfully and is Available Your Ticket is Available you can check in Ticket History"
        else
          flash[:success] = "Your Free Ticket is Available you can check in Ticket History"
        end  
        session[:order_id] = nil
      end  
    end
     @events=Event.all
       #used set_event on bottom and top
       #@review = Review.where(event_id: @event).order("created_At DESC")
    end
    
    def edit
        #used set_event on bottom and top
    end
    
    
    
    
    def update      
    if @event.update(event_params)
      flash[:success] = "Your Event was updated succesfully!"
      redirect_to event_path(@event)
    else
      render :edit
    end
  end
    
    
    
    
    def destroy
        #used set_event on bottom and top
        @event.destroy
        flash[:danger] = "You have successfully deleted the event"
        redirect_to events_path
    end
    
    def like
       #used set_event on bottom and top
       like = Like.create(like: params[:like], user: current_user, event: @event)
        if like.valid?
            flash[:success] = "Your selection was successfull"
            redirect_to :back
        else
           flash[:danger] = "You can only like/dislike a event once" 
           redirect_to :back
        end
    end
    
    
    def contact_email
      current_user.contact_emails.create(params[:event].permit!)
      email_sent = EventMailer.contact_email(@event,params[:event]).deliver_now rescue ""
      if email_sent
        flash[:success] = "Your Email has been successfully sent"
      else
        flash[:success] = "Your Email could not be sent"
      end  
      redirect_to :back
    end
    
    
    

    private
      

      def set_event
          @event = Event.find(params[:id])
      end      
      
      # def contact_email_params
      #   params.require(:contact_email).premit(:email, :subject, :body, :name, :phone, :user_id)
      # end  

      def event_params
          params.require(:event).permit(:name, :summary, :description, :address, :city, :zipcode, :state, :country, :picture, :latitude, :longitude,:user_id, :start_time, :end_time, :is_paid, :youtube_video, :vimeo_video,:event_type,:event_topic,:event_privacy,  category_ids: [], schedules_attributes: [:event_id, :image, :title, :description, :start_time, :end_time,:_destroy],tickets_attributes: [:event_id, :name, :price, :active, :quantity, :ticket_description, :show_ticket_description, :sale_channel, :fee, :tickets_start_date, :ticket_end_date, :currency, :country,:_destroy])
      end

end