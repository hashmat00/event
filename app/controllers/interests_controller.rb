class InterestsController < ApplicationController
	before_filter :set_reource, only: [:create]
	
	def create
		@interest = @resource.interests.find_or_create_by(user_id: current_user.id)
		interestParams = params[:interest][:flag] == 'nil' ? interest_params.merge(flag: nil, user_id: current_user.id) : interest_params
		@interest.update(interestParams)
	end	
	# def index
	# 	@interests = current_user.interests
	# end

	# def createuser_id
	# 	@event = Event.find(params[:event_id])
	# 	current_user.interests.create(interestable: @event, flag: true)
	# end

	# def destroy
	# 	@event = current_user.interests.find_by_event_id(params[:event_id])
	# 	@interest.destroy unless @event.blank?
	# end

	# def not_interested
	# 	@event = current_user.interests.where(interestable: params[:event_id]).first rescue ""
	# 	@temp = Event.find(params[:event_id]) 
	# 	@event.destroy unless @event.blank?
	# 	@event = @temp
	# end
	private
		def set_reource
			rcName = params[:interest][:interstable_type]
			@resource = rcName.constantize.where(id: params["#{rcName.downcase}_id"]).first
		end
		def interest_params
     params.require(:interest).permit(:user_id, :flag)
		end	

end