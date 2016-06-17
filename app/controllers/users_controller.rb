class UsersController < ApplicationController
	before_action :set_user, only: [:show]
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
    
 #    def require_same_user
 #    	if current_user != @user
    		
 #    		flash[:danger] = "You can only edit/delete your own Profile"
 #    		redirect_to user_path(@user)
 #    	end
 #    end
    	

end