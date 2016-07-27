class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  scope :active, ->{ where(is_active: true) }    
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
  ##Notifications
  has_many :sent_notifications,
   :class_name => 'Notification',
   :foreign_key => 'user_id'

  has_many :notifications,
   :class_name => 'Notification',
   :foreign_key => 'recipient_id'

  has_many :interests, :dependent => :destroy
  has_many :user_interests, :through => :interests, :source => :event
  has_many :ticket_histories, dependent: :destroy
  has_many :wish_lists, dependent: :destroy
  has_many :wish_lists_events, :through => :wish_lists, :source => :wish_listable, source_type: 'Event'
  has_many :contact_emails, dependent: :destroy
  # has_many :contact_details, dependent: :destroy
  has_many :contact_details, dependent: :destroy do
    def by_address_type(address_type_id)
       # use `self` here to access to current `Customer` record
       where(:address_type_id => address_type_id).first
    end
 end
 has_one :privacy, dependent: :destroy
 accepts_nested_attributes_for :privacy, :allow_destroy => true


  mount_uploader :image, PictureUploader
  has_many :carts, dependent: :destroy 
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

  def is_interested?(event)
    self.interests.where(:interestable_id => event.id).first.present?
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |user|
        csv << user.attributes.values_at(*column_names)
      end
    end
  end
end