class AddVideoToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :video, :string
  end
end
