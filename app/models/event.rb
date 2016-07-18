class Event < ActiveRecord::Base
    attr_accessor :email, :body, :phone, :message
    belongs_to :user
    geocoded_by :full_address
    geocoded_by :address
    scope :active, ->{ where(is_active: true) }
    scope :inactive, ->{ where(is_active: false) }
    after_validation :geocode, :if => :address_changed?

    has_many :like, dependent: :destroy
    has_many :event_categories, dependent: :destroy
    has_many :categories, through: :event_categories

    has_many :schedules, dependent: :destroy
    accepts_nested_attributes_for :schedules, :allow_destroy => true

    has_many :tickets, dependent: :destroy
    accepts_nested_attributes_for :tickets, :allow_destroy => true

    # validates :user_id, presence: true
    # validates :name, presence: true, length: { minimum: 3, maximum: 50}
    # validates :summary, presence: true, length: {minimum: 10, maximum: 250}
    # validates :description, presence: true, length: {minimum: 20, maximum: 10000}
    # validates :address, presence: true, length: {minimum: 5, maximum: 150}
    # validates :city, presence: true, length: {minimum: 3, maximum: 25}
    # validates :zipcode, presence: true, length: {minimum: 1, maximum: 20}
    # validates :state, presence: true, length: {minimum: 2, maximum: 20}
    # validates :country, presence: true, length: {minimum: 3, maximum: 55}   
   
   mount_uploader :picture, PictureUploader
   mount_uploader :video, AvatarUploader
   validate :picture_size
   default_scope -> { order(created_at: :desc) }
   has_many :interests, as: :interestable
   has_many :pictures, as: :picturable, dependent: :destroy
   accepts_nested_attributes_for :pictures, :allow_destroy => true
   has_many :videos, as: :videoable, dependent: :destroy
   accepts_nested_attributes_for :videos, :allow_destroy => true
   has_many :wish_lists, as: :wish_listable, dependent: :destroy
   scope :upcomming, -> { where('start_time  > ?',Time.now) }
  
  def wish_list_class(user_id)
    self.wish_lists.where(user_id:user_id).first.present? ? "glyphicon-heart" : "glyphicon-heart-empty"
  end 
  def full_address
    "#{address}, #{city}, #{state}, #{country}"
  end
   
  def thumbs_up_total
      self.like.where(like: true).size
  end
  
  def thumbs_down_total
      self.like.where(like: false).size
  end
  
  def picture_url
    self.picture.present? ? self.picture : "event_default.jpg"
  end

  def bgpicture_url
    self.picture.present? ? self.picture : "/assets/images/event_default.jpg"
  end
  
  def ticket_price
    self.tickets.collect(&:fee)
  end  

  def payMode(type)
    p = self.tickets.collect(&:pay_mode).uniq
    if p.count==0
      case type
      when "string" then
      when "amount" then 
        return 0.00
      when "all" then 
        return "Don't have Tickets"
      else
        return "Don't have Tickets"
      end
    elsif p.count==1
      if p.include?("free") || p.include?("Free") || p.include?("FREE") 
        case type
        when "string" then
          return "Free"
        when "amount" then 
          return 0.00
        when "all" then 
          return "Free"
        else
          return "Free"
        end    
      elsif p.include?("donation") || p.include?("Donation") || p.include?("DONATION")
        case type
        when "string" then
          return "Donation"
        when "amount" then 
          return 0.00
        when "all"   then
          return "Donation"
        else
          return "Donation"
        end
      elsif p.include?("paid") || p.include?("Paid") || p.include?("PAID")
        case type
        when "string" then
          return "Paid"
        when "amount" then 
          if self.tickets.minimum('price') == self.tickets.maximum('price')
            return '%.2f' % self.tickets.minimum('price')
          elsif self.tickets.minimum('price') == nil
            return self.tickets.maximum('price')
          elsif self.tickets.maximum('price') == nil
            return '%.2f' % self.tickets.minimum('price')
          else
            return "#{self.tickets.minimum('price')} - #{self.tickets.maximum('price')}"
          end  
        when "all" then
          if self.tickets.minimum('price') == self.tickets.maximum('price')
            return '%.2f' % self.tickets.minimum('price')
          elsif self.tickets.minimum('price') == nil
            return self.tickets.maximum('price')
          elsif self.tickets.maximum('price') ==nil
            return '%.2f' % self.tickets.minimum('price')
          else
             return "#{self.tickets.minimum('price')} - #{self.tickets.maximum('price')}"
          end
        else
          return "Paid"
        end
      end   
    elsif p.count > 1
      if p.include?("paid") || p.include?("Paid") || p.include?("PAID")
        case type
        when "string" then
          return "Paid"
        when "amount" then 
          if self.tickets.minimum('price') == self.tickets.maximum('price')
            return '%.2f' % self.tickets.minimum('price')
          elsif self.tickets.minimum('price') == nil
            return self.tickets.maximum('price')
          elsif self.tickets.maximum('price') == nil
            return '%.2f' % self.tickets.minimum('price')
          else
            "#{self.tickets.minimum('price')} - #{self.tickets.maximum('price')}"
          end  
        when "all" then
          if self.tickets.minimum('price') == self.tickets.maximum('price')
            return '%.2f' % self.tickets.minimum('price')
          elsif self.tickets.minimum('price') == nil
            return self.tickets.maximum('price')
          elsif self.tickets.maximum('price') == nil
              return '%.2f' % self.tickets.minimum('price')
          else
            return "#{self.tickets.minimum('price')} - #{self.tickets.maximum('price')}"
          end
        else
          return "Paid"
        end
      else
        case type
        when "string" then
          return "Free"
        when "amount" then 
          return 0.00
        when "all" then 
          return "Free"
        else
          return "Free"
        end
      end
    end  
  end

  def pay_mode_ammount
    
  end

  def pay_mode_all
    
  end
   
   private
   def picture_size
      if picture.size > 5.megabytes
          errors.add(:picture, "Should be less than 5MB")
      end
   end
    
    
    
end