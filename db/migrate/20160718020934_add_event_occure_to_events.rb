class AddEventOccureToEvents < ActiveRecord::Migration
  def change
  	add_column :schedules, :start_date, :datetime, default: Time.now
  	add_column :schedules, :end_date, :string, default: Time.now+1.months
    add_column :schedules, :event_occure, :string
    add_column :schedules, :event_day, :string
    add_column :schedules, :week_day, :string
    add_column :schedules, :month_day, :string
  end
end
