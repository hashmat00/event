class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.integer :user_id
      t.integer :interestable_id
      t.string :interestable_type

      t.timestamps null: false
    end
  end
end
