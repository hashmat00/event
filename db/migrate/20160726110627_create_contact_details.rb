class CreateContactDetails < ActiveRecord::Migration
  def change
    create_table :contact_details do |t|
      t.integer :user_id
      t.integer :address_type_id, default: 1
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :land_mark
      t.string :town
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.string :contact1
      t.string :contact2
      t.string :landline
      t.string :fax
      t.boolean :is_active, default:true

      t.timestamps null: false
    end
  end
end
