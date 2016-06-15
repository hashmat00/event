class CreateEventCategories < ActiveRecord::Migration
  def change
    create_table :event_categories do |t|
      t.integer :category_id, :event_id
    end
  end
end
