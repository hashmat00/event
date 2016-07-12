class AddIsActiveToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_active, :boolean, default: false
  end
end
