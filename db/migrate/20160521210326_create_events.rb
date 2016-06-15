class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :summary
      t.text :description
      t.string :address
      t.string :city
      t.string :zipcode
      t.string :state
      t.string :country
      
      t.timestamps
    end
  end
end
