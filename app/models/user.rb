class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
     
       has_many :events
       has_many :like

def self.sign_in_from_omniauth(auth)
        user = where(provider: auth['provider'], uid: auth['uid']).first_or_initialize 
        user.email =  auth['info']['email']
        user.name = auth['info']['name']
        user.password = Devise.friendly_token[0,20]
        user.save
        user
 end

      
    #    before_save { self.email = email.downcase }
    #    validates :username, presence: true, length: {minimum: 3, maximum: 40}
    #    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    #     validates :email, presence: true, length: {maximum: 50},
    #                         uniqueness: {case_sensitive: false },
    #                         format: { with: VALID_EMAIL_REGEX }
                            
                            
    # has_secure_password
end