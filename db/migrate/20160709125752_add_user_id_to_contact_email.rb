class AddUserIdToContactEmail < ActiveRecord::Migration
  def change
    add_column :contact_emails, :user_id, :integer
  end
end
