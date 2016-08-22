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
      @tab = Event.new
      # if params[:lat].present? && params[:long].present?
      # @temp_event = Event.new(latitude: params[:lat], longitude: params[:long])
      # else
      # @temp_event = Event.new(latitude: latlong[:lat], longitude: latlong[:long])  
      # end
      # @events = @temp_event.nearbys(params[:range].present? ? params[:range].to_i : 100, :order => "distance",:units => :km).active   
      # @events = Event.all.active if !(@events)
      # @events = @events.active.eager_load(:pictures,:videos,:tickets).references(:pictures,:videos,:tickets)
      # @events_pictures = @events.sort{|m| m.pictures.count }
      # @events_videos = @events.sort{|m| m.videos.count }
      # @events = @events
      set_events_data
      @users = User.all.active.eager_load(:events).where('events.is_active=?', true).references(:events).paginate(page: params[:page], per_page: 6)
      @categories = Category.eager_load(:events).shuffle
      # if request.format == "js"
      #   render :tabs
      # end  

      respond_to do |format|
      format.html { }
      format.js { render :tabs }
    end

    end

    def location_update
      @geocode =  Geocoder.search("#{params[:lat]},#{params[:long]}").first
    end

    def tabs
      if params[:single]
        @event = Event.where(id: params[:event_id]).first
      else  
        # if params[:lat].present? && params[:long].present?
        # @temp_event = Event.new(latitude: params[:lat], longitude: params[:long])
        # else
        # @temp_event = Event.new(latitude: latlong[:lat], longitude: latlong[:long])  
        # end        
        # @events = @temp_event.nearbys(params[:range].present? ? params[:range].to_i : 100, :order => "distance",:units => :km).active   
        # @events = Event.all.active if !(@events) 
        # @events = current_events.present? ? current_events : @events 
        # byebug
        # @events = @events.active.eager_load(:pictures,:videos,:tickets).references(:pictures,:videos,:tickets)
        # @events_pictures = @events.sort{|m| m.pictures.count }
        # @events_videos = @events.sort{|m| m.videos.count }
        # @events = @events
        set_events_data
      end  
    end

    def add_wishlist
      @wish_list = @event.wish_lists.where(user_id:current_user.try(:id)).first
      if @wish_list
       @wish_list = @wish_list.destroy
       @wish_list = false
      else
       @wish_list = @event.wish_lists.create(user_id:current_user.try(:id))
       @wish_list = true
      end  
    end  
    def new
        @event = Event.new
        @event.schedules.build
        @event.tickets.build
        @event.pictures.build
        @event.videos.build
    end
    
    def create
       @event = Event.new(event_params.merge(event_privacy: params[:event][:event_privacy]))
       cat_ids = params[:event][:categories].map(&:to_i).drop(1)
       @event.user = current_user
       if @event.save
        cat_ids.map{ |m| @event.event_categories.create(category_id: m)}
        Notification.notification(current_user, @event, "event", nil)
        flash[:success] = "You have successfully created the Event Please Launch Your Event by click on Launch My Event Button"
        redirect_to "/events/#{@event.id}/edit"
        else
            render 'new'
        end
    end
    
    
    def show
      @cart = Cart.new
      @tickets = Ticket.all
      @events = Event.all
    end
    
    def edit
        #used set_event on bottom and top
    end
    
    def update
    if params[:single] == "true"
      @event.update(is_active:params[:active])
      if params[:active] == "true"
         flash[:success] = "You have successfully Launch your event"
        redirect_to event_path(@event)
      else
        flash[:danger] = "You have successfully Inactive your event"
        redirect_to :back
      end  
    else  
      cat_ids = params[:event][:categories].map(&:to_i).drop(1)
      if @event.update(event_params)
        @event.event_categories.destroy_all
        cat_ids.map{ |m| @event.event_categories.create(category_id: m)}
        flash[:success] = "Your Event was updated succesfully!"
        if @event.is_active
          redirect_to event_path(@event)
        else
          redirect_to :back  
        end
      else
        render :edit
      end
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
      current_user.contact_emails.create(params[:event].permit!) rescue ""
      email_sent = EventMailer.contact_email(@event,params[:event]).deliver_now rescue ""
      if email_sent
        flash[:success] = "Your Email has been successfully sent"
      else
        flash[:success] = "Your Email could not be sent"
      end  
      redirect_to :back
    end
    
    
    # def subregion_options
    #   render partial: 'subregion_select'
    # end

    private
      

      def set_event
          @event = Event.find(params[:id])
      end      
      
      # def contact_email_params
      #   params.require(:contact_email).premit(:email, :subject, :body, :name, :phone, :user_id)
      # end  

      def event_params
          params.require(:event).permit(:name, :summary, :description, :address, :city, :zipcode, :state, :country, :picture, :latitude, :longitude,:user_id, :start_time, :end_time, :is_paid, :youtube_video, :vimeo_video,:event_type,:event_topic,:event_privacy, schedules_attributes: [:id,:event_id, :image, :title, :description, :start_date, :end_date, :start_time, :end_time, :event_occure, :event_day, :week_day, :month_day, :_destroy], pictures_attributes: [:id,:user_id, :image, :note, :_destroy], videos_attributes: [ :id,:user_id, :video_url,:videoable_id, :videoable_type, :is_active, :video,:video_type,:note,:_destroy], tickets_attributes: [:id,:event_id, :name, :price, :active, :quantity, :ticket_description, :show_ticket_description, :sale_channel, :fee, :tickets_start_date, :ticket_end_date, :currency, :country, :pay_mode, :_destroy])
      end

      def set_events_data
        @events = current_events.present? ? current_events : all_events
        @events_pictures = @events.sort{|m| m.pictures.count }
        @events_videos = @events.sort{|m| m.videos.count }
      end 

end