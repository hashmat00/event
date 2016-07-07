class Add < ActiveRecord::Migration
  def change
  	add_column :orders, :order_uid, :string
  end
end
