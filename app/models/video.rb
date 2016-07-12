class Video < ActiveRecord::Base
	belongs_to :videoable, polymorphic: true
	# mount	_uploader :video, MediaUploader
end
