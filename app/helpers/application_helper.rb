module ApplicationHelper
    

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  class InetInput < Formtastic::Inputs::StringInput
end



    #use image from gravatar.com 
    def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.username, class: "gravatar")
  end

  def only_us_and_canada
    Carmen::Country.all.select{|c| %w{US CA}.include?(c.code)}
  end

end
