class EventsController < ApplicationController
    before_action :set_event, only: [:edit, :update, :show, :like, :destroy]
    before_action :require_user, except: [:show, :index]
    before_action :require_same_user, only: [:edit, :destory, :update]
    
    
    
    
    def index
        # @events = Event.all.sort_by{|likes| likes.thumbs_up_total}.reverse
        @events = Event.paginate(page: params[:page], per_page: 6)
    end
    
    
    
    
    def new
        @event = Event.new
    end
    
    def create
       @event = Event.new(event_params)
       @event.user = current_user
       if @event.save
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
    
        def event_params
        params.require(:event).permit(:name, :summary, :description, :address, :city, :zipcode, :state, :country, :picture, category_ids: [])
    end
    
    
    def set_event
        @event = Event.find(params[:id])
    end
    
    
    def require_same_user
        if current_user != @event.user && !current_user.admin?
        	flash[:danger] = "You can only edit/delete your own event"
    		redirect_to root_path
    	end
    end
end