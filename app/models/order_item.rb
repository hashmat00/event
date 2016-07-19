class OrderItem < ActiveRecord::Base
 belongs_to :ticket
  belongs_to :order
  belongs_to :event

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :ticket_present
  validate :order_present

  before_save :finalize
  serialize :notification_params, Hash
  def unit_price
    if persisted?
      self[:unit_price] rescue 0
    else
      self.ticket.try(:price) rescue 0
    end
  end

  def total_price
    unit_price * quantity if unit_price.present? rescue 0
  end

  def self.paypal_url(return_url, subtotal, event_id, ticket_id, size)
    event = Event.where(id: event_id).first
    ticket = Ticket.where(id: ticket_id).first
    values = {
      :business =>  'rorfuture-facilitator@gmail.com',
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :invoice => rand.to_s[2..7].to_i,
      notify_url: "#{Rails.application.secrets.app_host}/hook",
      "amount_1" => subtotal,
        "item_name_1" => ticket.try(:name) + " ticket for " + event.try(:name),
        "item_number_1" => rand.to_s[2..9].to_i,
        "quantity_1" => size
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
    self[:unit_price] = unit_price rescue 0
    self[:total_price] = quantity * self[:unit_price] rescue 0
  end
end
