class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception 
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :current_events
  helper_method :current_events
  helper_method :latlong
  helper_method :baseUrl
  helper_method :requestUrl
  helper_method :current_city
  before_filter :current_tab1
  before_filter :current_tab2
  helper_method :current_tab1
  helper_method :current_tab2
  helper_method :current_state
  helper_method :current_counttry

  def current_tab1
    
    if params[:controller] == "events" && params[:action] == "tabs"
      if (params[:tab].to_i) > 0 && (params[:tab].to_i) < 4
        session[:current_tab_id] =  params[:tab]
        current_tab_id = session[:current_tab_id]
      end
    end
  end
  def current_tab2
    
    if params[:controller] == "events" && params[:action] == "tabs"
      if params[:tab].to_i > 3 && (params[:tab].to_i) < 8
        session[:current_tab_id] =  params[:tab]
        current_tab_id = session[:current_tab_id]
      end
    end
  end  

  def current_events
    if params[:form_filter]
      distanceInput = params[:distanceInput].present? ? params[:distanceInput].to_i : 100
      if params[:filterLocation]
        begin
          case params[:locationFilter]
          when "currentLocationOn" then 
            @temp_event = Event.new(latitude: latlong[:lat], longitude: latlong[:long])
            current_events = @temp_event.nearbys(distanceInput, :order => "distance",:units => :km).active 
          when "customLocationOn" then 
            latitude = Geocoder.search(params[:address]).first.latitude
            longitude = Geocoder.search(params[:address]).first.longitude
            @temp_event = Event.new(latitude: latitude, longitude: longitude)
            current_events = @temp_event.nearbys(distanceInput, :order => "distance",:units => :km).active 
          when "currentCityOn" then
            current_events = Event.all.active.near(current_city, distanceInput, order: :distance)
          when "customCityOn" then 
            current_events = Event.all.active.near(params[:city_filter], distanceInput, order: :distance)
          when "currentStateOn" then
            current_events = Event.all.active.near(current_state, distanceInput, order: :distance)
          when "customStateOn" then
            current_events = Event.all.active.near(params[:state_filter], distanceInput, order: :distance)
          when "currentCountryOn" then
            current_events = Event.all.active.near(current_country, distanceInput, order: :distance)
          when "customCountryOn" then
            current_events = Event.all.active.near(params[:country_filter], distanceInput, order: :distance)
          end
        rescue
          nil
        end    
      else
        begin
          @temp_event = Event.new(latitude: latlong[:lat], longitude: latlong[:long])
          current_events = @temp_event.nearbys(distanceInput, :order => "distance",:units => :km).active
        rescue
          current_events = Event.all
        end  
      end
      if params[:filterDate]
        begin
          case params[:dateFilter]
          when "upcommingEventOn" then
            current_events = current_events.where('events.start_time > ?', Time.now)
          when "pastEventOn" then
            current_events = current_events.where('events.end_time < ?', Time.now)
          when "todayEventOn" then
            current_events = current_events.where("start_time >= ?", Time.zone.now.beginning_of_day)
          when "yesterdayEventOn" then
            current_events = current_events.where("DATE(start_time) = ?", Date.today-1)
          when "tomorrowEventOn" then
            current_events = current_events.where("DATE(start_time) = ?", Date.today+1)
          when "tomorrowAfterEventOn" then
            current_events = current_events.where("DATE(start_time) = ?", Date.today+2)
          when "currentWeekEventOn" then
            current_events = current_events.where(start_time: Date.today.beginning_of_week..Date.today.end_of_week)
          when "currentMonthEventOn" then
            current_events = current_events.where(start_time: Date.today.beginning_of_month..Date.today.end_of_month)
          when "currentYearEventOn" then
            current_events = current_events.where(start_time: Date.today.beginning_of_year..Date.today.end_of_year)
          when "7DaysEventOn" then
            current_events = current_events.where(start_time: Time.now..(Date.today+7.days).end_of_day)
          when "31DaysEventOn" then
            current_events = current_events.where(start_time: Time.now..(Date.today+31.days).end_of_day)
          when "365DaysEventOn" then
            current_events = current_events.where(start_time: Time.now..(Date.today+365.days).end_of_day)
          when "customDateEventOn" then
            current_events = current_events.where("start_time >=  ? and start_time <= ?", start_time, end_time)
          end
        rescue
          nil
        end    
      end
      if params[:filterPrice]
        begin
          current_events = current_events.eager_load(:tickets).where(tickets:{active:true})
          case params[:priceFilter]
          when "allPriceOn" then
            current_events = current_events.eager_load(:tickets)
          when "freePriceOn" then
            current_events = current_events.eager_load(:tickets).where(tickets:{pay_mode:"free"})
          when "paidPriceOn" then
            current_events = current_events.eager_load(:tickets).where(tickets:{pay_mode:"paid"})
          when "freePaidPriceOn" then
            current_events = current_events.eager_load(:tickets).where(tickets: {pay_mode: ["free","paid"]})
          when "donationPriceOn" then
            current_events = current_events.eager_load(:tickets).where(tickets:{pay_mode:"donation"})
          when "freeDonationPriceOn" then
            current_events = current_events.eager_load(:tickets).where(tickets: {pay_mode: ["free","donation"]})
          when "paidDonationPriceOn" then 
            current_events = current_events.eager_load(:tickets).where(tickets: {pay_mode: ["paid","donation"]})
          end  
        rescue
          nil
        end
      end
      if params[:filterCategory]
        begin
          current_events = current_events.eager_load(:categories).where(categories: {id: params[:category].map(&:to_i)} )
        rescue
          nil
        end 
      end
      if params[:filterEventType]
        begin
          current_events = current_events.where(event_type: params[:event_type])
        rescue
          nil
        end  
      end
      begin
        current_events = current_events.eager_load(:pictures,:videos,:tickets).references(:pictures,:videos,:tickets)
      rescue
        nil
      end
    end    
  end
  def latlong
    {lat: request.location.latitude!=0 ? request.location.latitude : '28.6139', long: request.location.longitude!=0 ? request.location.longitude : '77.2090'}
  end

  def current_city
    request.location.city!="" ? request.location.city : 'New Delhi'
  end 
   def current_state
    request.location.state!="" ? request.location.state : 'Delhi'
  end  

   def current_counttry
    request.location.country!="" ? request.location.country : 'India'
  end  
    
  def baseUrl
    request.base_url
  end
  def requestUrl
    request.url
  end
  
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user|
        user.permit(:username, :email, :password, :password_confirmation, :current_password, :username, :email, :password, :password_confirmation, :image, :name, :about_organizer, :website_url, privacy_attributes: [:id, :user_id, :is_email, :is_message, :is_notification, :is_visible])
    end
    devise_parameter_sanitizer.permit(:account_update) do |user|
        user.permit(:username, :email, :password, :password_confirmation, :current_password, :username, :email, :password, :password_confirmation, :image, :name, :about_organizer, :website_url, privacy_attributes: [:id, :user_id, :is_email, :is_message, :is_notification, :is_visible])
    end
  end
end
