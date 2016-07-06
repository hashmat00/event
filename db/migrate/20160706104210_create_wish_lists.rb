class CreateWishLists < ActiveRecord::Migration
  def change
    create_table :wish_lists do |t|
      t.integer :user_id
      t.integer :wish_listable_id
      t.string :wish_listable_type
      t.boolean :is_active, default: true

      t.timestamps null: false
    end
  end
end
