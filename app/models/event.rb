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

    validates :user_id, presence: true
    validates :name, presence: true#, length: { minimum: 3, maximum: 50}
    validates :description, presence: true#, length: {minimum: 20, maximum: 10000}
    validates :address, presence: true#, length: {minimum: 5, maximum: 150}
    validates :city, presence: true#, length: {minimum: 3, maximum: 25}
    validates :zipcode, presence: true
    validates :state, presence: true#, length: {minimum: 2, maximum: 20}
    validates :country, presence: true#, length: {minimum: 2, maximum: 55}  
    validates :start_time, presence: true
    validates :end_time, presence: true
    # validates :event_type, presence: true
    # validates :event_topic, presence: true 
    # validates :event_privacy, presence: true 
   
   mount_uploader :picture, PictureUploader
   mount_uploader :video, AvatarUploader
   validate :picture_size
   # validate :event_date
   # validate :ticket_price
   # default_scope -> { order(created_at: :desc) }
   has_many :interests, as: :interestable, dependent: :destroy
   has_many :pictures, as: :picturable, dependent: :destroy
   accepts_nested_attributes_for :pictures, :allow_destroy => true
   has_many :videos, as: :videoable, dependent: :destroy
   accepts_nested_attributes_for :videos, :allow_destroy => true
   has_many :wish_lists, as: :wish_listable, dependent: :destroy
   scope :upcomming, -> { where('start_time  > ?',Time.now).try(:active) }
   scope :past, -> { where('end_time  < ?',Time.now).try(:active) }
   before_save :address_fill

   def interested
      self.interests.where(interests: {flag: true})   
   end 
   def partially_interested
      self.interests.where(interests: {flag: nil})   
   end
   def not_interested
    self.interests.where(interests: {flag: false})   
   end 

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
        "Don't have Tickets"
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
            return '%.2f' % self.tickets.minimum('price') rescue 0
          elsif self.tickets.minimum('price') == nil
            return self.tickets.maximum('price') rescue 0
          elsif self.tickets.maximum('price') == nil
            return '%.2f' % self.tickets.minimum('price') rescue 0
          else 
            return "#{self.tickets.minimum('price')} - $#{self.tickets.maximum('price')}" rescue 0
          end  
        when "all" then
          if self.tickets.minimum('price') == self.tickets.maximum('price')
            return '%.2f' % self.tickets.minimum('price')
          elsif self.tickets.minimum('price') == nil
            return self.tickets.maximum('price')
          elsif self.tickets.maximum('price') ==nil
            return '%.2f' % self.tickets.minimum('price')
          else
             return "#{self.tickets.minimum('price')} - $#{self.tickets.maximum('price')}"
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
            "#{self.tickets.minimum('price')} - $#{self.tickets.maximum('price')}"
          end  
        when "all" then
          if self.tickets.minimum('price') == self.tickets.maximum('price')
            return '%.2f' % self.tickets.minimum('price')
          elsif self.tickets.minimum('price') == nil
            return self.tickets.maximum('price')
          elsif self.tickets.maximum('price') == nil
              return '%.2f' % self.tickets.minimum('price')
          else
            return "#{self.tickets.minimum('price')} - $#{self.tickets.maximum('price')}"
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
  
  def address_fill
    if event_type == "online"
      self.update(address: "This is an Online Evemt NO location filled", city: nil, status: nil, zipcode: nil, country: nil)
    end 
  end

  def self.filterMethod(params)
    custom_location(params) if params[:locationFilter] == "customLocationOn"
    temp_event = Event.new(latitude: params[:latlong][:lat], longitude: params[:latlong][:long])
    current_events = temp_event.nearbys(params[:distanceInput], :order => "distance",:units => :km).active 
    current_events = location_filter(params,current_events) if params[:filterLocation].present?
    current_events = date_filter(params,current_events) if params[:filterDate].present?
    current_events = price_filter(params,current_events) if params[:filterPrice].present?
    current_events = category_filter(params,current_events) if params[:filterCategory].present?
    current_events = event_type_filter(params,current_events) if params[:filterEventType].present?
    return current_events
  end

  def self.custom_location(params)
    gecodeloc = Geocoder.search(params[:address]).first
    params[:latlong].merge(lat: gecodeloc.latitude, long: longitude)      
  end  
  
  def self.location_filter(params,current_events)
    case params[:locationFilter]
      when "currentLocationOn" then 
        return current_events
      when "customLocationOn" then 
        return current_events
      when "currentCityOn" then
        return current_events = Event.all.active.near(params[:current_city], params[:distanceInput], order: :distance)
      when "customCityOn" then 
        return current_events = Event.all.active.near(params[:city_filter], params[:distanceInput], order: :distance)
      when "currentStateOn" then
        return current_events = Event.all.active.near(params[:current_state], params[:distanceInput], order: :distance)
      when "customStateOn" then
        return current_events = Event.all.active.near(params[:state_filter], params[:distanceInput], order: :distance)
      when "currentCountryOn" then
        return current_events = Event.all.active.near(params[:current_country], params[:distanceInput], order: :distance)
      when "customCountryOn" then
        return current_events = Event.all.active.near(params[:country_filter], params[:distanceInput], order: :distance)
      end
  end
  def self.date_filter(params,current_events)
  end
  def self.price_filter(params,current_events)
  end
  def self.category_filter(params,current_events)
  end
  def self.event_type_filter(params,current_events)
  end 

  private
  def picture_size
    if picture.size > 5.megabytes
        errors.add(:picture, "Should be less than 5MB")
    end
  end
  def event_date
    if self.start_time > self.end_time
      errors.add(:_, "event start time could not greater than event end time")
    end
    if self.end_time < self.start_time
      errors.add(:_, "event end time could not greater than event start time")
    end
    self.schedules.each do |schedule|
      if schedule.start_date < self.start_time
        errors.add(:_, "schedule start date could not less then event start time")
      end
      if schedule.start_date > self.end_time  
        errors.add(:_, "schedule start date could not greater then event end time")
      end
      if schedule.start_date > schedule.end_date  
        errors.add(:_, "schedule start date could not greater then shcedule end date")
      end
      if schedule.end_date < self.start_time
        errors.add(:_, "schedule end date could not less then event start time")
      end
      if schedule.end_date > self.end_time
        errors.add(:_, "schedule end date could not greater then event end time")  
      end
      if schedule.end_date < schedule.start_date  
        errors.add(:_, "schedule end date could not less then schedule start date")
      end
    end
    self.tickets.each do |ticket|
      if ticket.tickets_start_date > self.end_time  
        errors.add(:_, "Ticket sale start date could not greater then schedule end time")
      end
      if ticket.tickets_start_date > ticket.ticket_end_date  
        errors.add(:_, "Ticket sale start date could not greater then Ticket sale end date")
      end
      if ticket.ticket_end_date > self.end_time
        errors.add(:_, "Ticket sale end date could not greater then event end time")  
      end
      if ticket.ticket_end_date < ticket.tickets_start_date 
        errors.add(:_, "Ticket sale end date could not less then Ticket sale start date") 
      end
    end  

  end 
end