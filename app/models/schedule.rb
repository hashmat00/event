class Schedule < ActiveRecord::Base
	belongs_to :event
	mount_uploader :image, PictureUploader
end
