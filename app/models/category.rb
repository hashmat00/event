class Category < ActiveRecord::Base
  validates :name, presence: true, length:{ minimum: 2, maximum: 25 }, uniqueness: { case_sensitive: false }
  has_many :event_categories
  has_many :events, through: :event_categories    
end