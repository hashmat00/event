class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
    	t.integer :user_id, default: 1
      t.string :video_url, default: "http://www.youtube.com/watch?v=mZqGqE0D0n4"
 	     t.integer :videoable_id
      t.string :videoable_type
      t.boolean :is_active, default: true
      t.string :video
      t.string :video_type, default: "youtube"
      t.text :note
      t.timestamps null: false
    end
  end
end
