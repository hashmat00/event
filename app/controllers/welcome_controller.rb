class WelcomeController < ApplicationController
    

    
    def home

        @users = User.all
        # paginate(page: params[:page], per_page: 4)
        @events = Event.all
        # paginate(page: params[:page], per_page: 3)
        redirect_to events_path if user_signed_in?
        
    end
    
    def about
        
    end

    def set_auth
  	@auth = session[:omniauth]
  end
    
    
end
