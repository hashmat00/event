class AddIsActiveToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :is_active, :boolean, default: true
  end
end
