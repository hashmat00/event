class CreateContactEmails < ActiveRecord::Migration
  def change
    create_table :contact_emails do |t|
      t.string :email
      t.string :subject
      t.string :body
      t.string :name
      t.string :phone

      t.timestamps null: false
    end
  end
end
