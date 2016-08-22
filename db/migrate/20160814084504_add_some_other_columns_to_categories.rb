class AddSomeOtherColumnsToCategories < ActiveRecord::Migration
  def change
  	add_column :categories, :image, :string
  	add_column :categories, :sub_title, :string
  	add_column :categories, :is_active, :boolean, default: true
  	add_column :categories, :rank, :string
  end
end
