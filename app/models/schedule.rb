class Schedule < ActiveRecord::Base
	belongs_to :event
	mount_uploader :image, PictureUploader
	validates :title, presence: true
	validates :description, presence: true
	validates :start_date, presence: true
	validates :end_date, presence: true
	
end
