class AddIsActiveToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :is_active, :boolean, default: true
    add_column :ticket_histories, :is_active, :boolean, default: true
  end
end
