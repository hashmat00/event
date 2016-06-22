class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :recipient_id
      t.integer :notificable_id
      t.string :notificable_type
      t.datetime :readt_at
      t.text :body
      t.boolean :accept, :defualt =>false

      t.timestamps null: false
    end
  end
end
