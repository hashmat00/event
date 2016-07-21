class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :payment_id
      t.integer :quantity, default: 0
      t.string :code, default: SecureRandom.hex(4).upcase
      t.integer :subscriptionable_id
      t.string :subscriptionable_type, default: "Ticket"
      t.string :order_id, default: SecureRandom.hex(8)
      t.decimal :unit_price, precision: 12, scale: 2, default: 0
      t.decimal :total_price, precision: 12, scale: 2, default: 0
      t.datetime :purchased_at, default: Time.now
      t.integer :transaction_id
      t.string :note
      t.string :pay_mode, default: "free"
      t.integer :pay_method_id
      t.boolean :is_active, default: true
      t.timestamps null: false
    end
  end
end
