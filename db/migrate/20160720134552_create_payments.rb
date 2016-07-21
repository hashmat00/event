class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :subscription_id
      t.integer :cart_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :contact_no
      t.boolean :is_active, default: true

      t.timestamps null: false
    end
  end
end
