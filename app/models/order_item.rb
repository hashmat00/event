class OrderItem < ActiveRecord::Base
 belongs_to :ticket
  belongs_to :order
  belongs_to :event

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :ticket_present
  validate :order_present

  before_save :finalize

  def unit_price
    if persisted?
      self[:unit_price]
    else
      ticket.price
    end
  end

  def total_price
    unit_price * quantity
  end

  def self.paypal_url(return_url)
    values = {
      :business => 'rorfuture-facilitator@gmail.com',
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :invoice => 12121,
      "amount_1" => 10,
        "item_name_1" => "item.product.name",
        "item_number_1" => 23,
        "quantity_1" => 1
    }
    # line_items.each_with_index do |item, index|
    #   values.merge!({
    #     "amount_#{index+1}" => item.unit_price,
    #     "item_name_#{index+1}" => item.product.name,
    #     "item_number_#{index+1}" => item.id,
    #     "quantity_#{index+1}" => item.quantity
    #   })
    # end
  "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end

private
  def ticket_present
    if ticket.nil?
      errors.add(:ticket, "is not valid or is not active.")
    end
  end

  def order_present
    if order.nil?
      errors.add(:order, "is not a valid order.")
    end
  end

  def finalize
    self[:unit_price] = unit_price
    self[:total_price] = quantity * self[:unit_price]
  end
end
