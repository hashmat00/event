class AddPercentageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :percentage, :float, default: 90.00
    add_column :users, :is_active_paypal, :boolean, default: false
    add_column :users, :is_trusted, :boolean, default: false
    add_column :users, :is_refundable, :boolean, default: false
  end
end
