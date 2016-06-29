class InterestsController < ApplicationController

	def index
		@interests = current_user.interests
	end

	def create
		@event = Event.find(params[:event_id])
		current_user.interests.create(interestable: @event)
	end

	def destroy
		@event = current_user.interests.find_by_event_id(params[:event_id])
		@interest.destroy unless @event.blank?
	end

	def not_interested
		@event = current_user.interests.where(interestable: params[:event_id]).first
		@event.destroy unless @event.blank?
	end

end