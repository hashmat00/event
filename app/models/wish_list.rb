class WishList < ActiveRecord::Base
	belongs_to :wish_listable, polymorphic: true
	belongs_to :user
end
