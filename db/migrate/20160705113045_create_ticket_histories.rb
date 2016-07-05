class CreateTicketHistories < ActiveRecord::Migration
  def change
    create_table :ticket_histories do |t|
      t.integer :user_id
      t.integer :ticket_id
      t.integer :order_id
      t.integer :event_id
      t.integer :quantity
      t.timestamps null: false
    end
  end
end
