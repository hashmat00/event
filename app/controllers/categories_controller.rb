class CategoriesController < ApplicationController
    before_action :require_user, except: [:show]
    
    
   def show
    @category = Category.find(params[:id])
     @events = @category.events.paginate(page: params[:page], per_page: 4)
   end
   
   def new
     @category = Category.new
   end
    
    
    def create
        @category = Category.create(category_params)
        if @category.save
           flash[:success] = "You have successfully created the category"
           redirect_to events_path
        else
            render 'new'
        end
        
    end
    
    
    
    private
        
        def category_params
            params.require(:category).permit(:name)
        end
    
end