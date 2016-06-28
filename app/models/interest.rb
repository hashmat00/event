class Interest < ActiveRecord::Base
	belongs_to :interestable, polymorphic: true
 	belongs_to :user#, inverse_of: :favorites
end
