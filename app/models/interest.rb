class Interest < ActiveRecord::Base
	belongs_to :interestable, polymorphic: true
 	belongs_to :user#, inverse_of: :favorites
 	belongs_to :event
	
	def message
		case self.flag
		when true then "you are Interested to attand This Event"
		when nil then "you may be attand This Event"
		when false then "you are not interested to attand This Event"	
		end
	end 	
end
