class AddPayModeToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :pay_mode, :string, default: "free"
  end
end
