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

	## getter and setter methods
	attr_accessor :sender_id
end
