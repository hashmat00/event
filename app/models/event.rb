class Event < ActiveRecord::Base
   
    belongs_to :user
    geocoded_by :full_address
    geocoded_by :address
    after_validation :geocode, :if => :address_changed?






    has_many :like, dependent: :destroy
    has_many :event_categories, dependent: :destroy
    has_many :categories, through: :event_categories
    
    validates :user_id, presence: true
    validates :name, presence: true, length: { minimum: 3, maximum: 50}
    validates :summary, presence: true, length: {minimum: 10, maximum: 250}
    validates :description, presence: true, length: {minimum: 20, maximum: 1000}
    validates :address, presence: true, length: {minimum: 5, maximum: 55}
    validates :city, presence: true, length: {minimum: 3, maximum: 25}
    validates :zipcode, presence: true, length: {minimum: 1, maximum: 20}
    validates :state, presence: true, length: {minimum: 2, maximum: 20}
    validates :country, presence: true, length: {minimum: 3, maximum: 55}
   
   
   mount_uploader :picture, PictureUploader
   validate :picture_size
   default_scope -> { order(created_at: :desc) }
   
  def full_address
    "#{address}, #{city}, #{state}, #{country}"
  end
   
  def thumbs_up_total
      self.like.where(like: true).size
  end
  
  def thumbs_down_total
      self.like.where(like: false).size
  end
  
  
   
   private
   def picture_size
      if picture.size > 5.megabytes
          errors.add(:picture, "Should be less than 5MB")
      end
   end
    
    
    
end