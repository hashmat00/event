class Notification < ActiveRecord::Base
	## Model Associations
	belongs_to :recipient, class_name: "User"
	belongs_to :user, class_name: "User"
	belongs_to :notificable, :polymorphic => true

	## Scopes
	scope :unread, ->{ where(accept: false) }
	scope :read, ->{ where(accept: true) }
	scope :messages, ->{ where(notificable_type: 'Message') }
	scope :friend_requests, ->{ where(notificable_type: 'Friendship') }
	scope :active, ->{ where(is_active: true) }
  scope :inactive, ->{ where(is_active: false) }
	## getter and setter methods
	attr_accessor :sender_id

	def self.notification(user,resource, resource_type, recipient)
		case resource_type
		when 'event' then 
			user.user.notifications.create(user_id: user.id, body: "you have created event #{resource.name} ", notificable: resource, accept: false)
			if user.followers.present?
				user.followers.each_with_index do |follower, index|
					follower.notifications.create(user_id: user.id, body: "#{user.name} has create a event #{resource.name}
#{resource.name}", notificable: resource, accept: false)
				end	
			end
			if user.following.present?
				user.following.each_with_index do |following, index|
					following.notifications.create(user_id: user.id, body: "#{user.name} has create a event #{resource.name}
#{resource.name}", notificable: resource, accept: false)
				end	
			end 	
		when 'follow' then 
			recipient.notifications.create(user_id: user.id, body: "#{user.name} has followed you.", notificable: recipient, accept: false)
		when 'unfollow' then 
			recipient.notifications.create(user_id: user.id, body: "#{user.name} has unfollowed you.", notificable: recipient, accept: false)
		end
	end
end
