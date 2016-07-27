class CreatePrivacies < ActiveRecord::Migration
  def change
    create_table :privacies do |t|
      t.integer :user_id
      t.boolean :is_email, default: true
      t.boolean :is_message, default: true
      t.boolean :is_notification, default: true
      t.boolean :is_visible, default: true

      t.timestamps null: false
    end
  end
end
