class WelcomeController < ApplicationController
    
    def home
        @users = User.paginate(page: params[:page], per_page: 4)
        @events = Event.paginate(page: params[:page], per_page: 3)
        redirect_to events_path if logged_in?
        
    end
    
    def about
        
    end
    
    
end
