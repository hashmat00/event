class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.string :reviewable_type
      t.integer :reviewable_id
      t.text :body
      t.float :rating
      t.boolean :is_active
      t.string :reviewer_name
      t.string :reviewer_email

      t.timestamps null: false
    end
  end
end
