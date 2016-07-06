class Ticket < ActiveRecord::Base
  belongs_to :event
  has_many :order_items

  default_scope { where(active: true) }
  def pay_type
  	self.fee ? "Paid" : "Free"
  end
end
