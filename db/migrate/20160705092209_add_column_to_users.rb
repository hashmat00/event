class AddColumnToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :about_organizer, :string
  	add_column :users, :website_url, :string
  end
end
