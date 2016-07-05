class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.integer :user_id, default: 1
      t.integer :picturable_id
      t.string :picturable_type
      t.boolean :is_active, default: true
      t.string :image
      t.text :note

      t.timestamps null: false
    end
  end
end
