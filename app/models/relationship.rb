class Relationship < ActiveRecord::Base
	belongs_to :follower, class_name: "User"
    belongs_to :followed, class_name: "User"
    validates :follower_id, presence: true
    validates :followed_id, presence: true
    validate :ambiguity

    def ambiguity
    	if self.follower_id == self.followed_id
    		errors.add(:_, "you can not followed your self")
    	end
    	if Relationship.all.collect(&:follower_id).include?(self.follower_id) && Relationship.all.collect(&:followed_id).include?(self.followed_id)
    		errors.add(:_, "ambiguity record can not create")
    	end
    end
end
