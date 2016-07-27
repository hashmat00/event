class AddSomeOtherColumnsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :prefix, :string
  	add_column :users, :first_name, :string
	add_column :users, :last_name, :string
	add_column :users, :job_title, :string
	add_column :users, :company, :string
	add_column :users, :blog, :string
	add_column :users, :dob, :string
	add_column :users, :gender, :string
	add_column :users, :google_url, :string
	add_column :users, :fb_url, :string
	add_column :users, :twitter_url, :string
	add_column :users, :linkedin_url, :string
	add_column :users, :primary_email, :string
	add_column :users, :secondary_email, :string
	add_column :users, :paypal_email, :string	
  end
end
