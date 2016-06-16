class AddUsernameToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :usersname, :string
  end
end
