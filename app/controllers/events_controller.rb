class EventsController < ApplicationController

    before_action :set_event, only: [:edit, :update, :show, :like, :destroy]
    before_action :require_same_user, only: [:edit, :destory, :update]    
    before_action :authenticate_user!, only: [:edit, :update, :destroy, :like]
    
    
  def index

        # @events = Event.all.sort_by{|likes| likes.thumbs_up_total}.reverse

    if params[:category].present?  
         @categories = Category.find(params[:category])
         @events = @categories.events.where("address LIKE? ", "%#{params[:search]}%" ).near(params[:search], params[:distance], :order => 'address')
        elsif params[:search]
         @events = Event.where("address LIKE? ", "%#{params[:search]}%" )
        elsif params[:distance]
         city =  Rails.env == 'development' ? 'Delhi' : request.location.city
         @events = Event.near(city, params[:distance], :order => :address)  
        else
         @events = Event.all
        # paginate(page: params[:page], per_page: 6)
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
    
    
    
    
    
    

    private
    
      def set_event
          @event = Event.find(params[:id])
      end      
      def event_params
          params.require(:event).permit(:name, :summary, :description, :address, :city, :zipcode, :state, :country, :picture, :latitude, :longitude,:user_id, :start_time, :end_time, category_ids: [])
      end
end