class AddColumnToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :event_type, :string
  	add_column :events, :event_topic, :string
  	add_column :events, :event_privacy, :boolean
  end
end
