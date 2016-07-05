class AddColumnToTicket < ActiveRecord::Migration
  def change
  	add_column :tickets, :quantity, :string
  	add_column :tickets, :ticket_description, :string
  	add_column :tickets, :show_ticket_description, :boolean
  	add_column :tickets, :sale_channel, :string
  	add_column :tickets, :fee, :string
  	add_column :tickets, :tickets_start_date,:datetime
  	add_column :tickets, :ticket_end_date, :datetime
  	add_column :tickets, :country, :string
  	add_column :tickets, :currency, :string
  end
end
