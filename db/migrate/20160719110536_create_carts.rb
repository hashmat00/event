class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :user_id
      t.integer :cartable_id
      t.string :cartable_type, default: "Ticket"
      t.integer :quantity, default: 0
      t.decimal :unit_price, precision: 12, scale: 2, default: 0
      t.decimal :total_price, precision: 12, scale: 2, default: 0
      t.boolean :is_active, default: true
      t.string :pay_mode
      t.string :note

      t.timestamps null: false
    end
  end
end
