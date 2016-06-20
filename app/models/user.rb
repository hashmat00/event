class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
     
  has_many :events
  has_many :like
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  def self.sign_in_from_omniauth(auth)
        user = where(provider: auth['provider'], uid: auth['uid']).first_or_initialize 
        user.email =  auth['info']['email']
        user.name = auth['info']['name']
        user.password = Devise.friendly_token[0,20]
        user.save
        user
  end

  def admin?
    self.is_admin
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

      
    #    before_save { self.email = email.downcase }
    #    validates :username, presence: true, length: {minimum: 3, maximum: 40}
    #    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    #     validates :email, presence: true, length: {maximum: 50},
    #                         uniqueness: {case_sensitive: false },
    #                         format: { with: VALID_EMAIL_REGEX }
                            
                            
    # has_secure_password
end