class AddSubscriptionIdToTicketHistory < ActiveRecord::Migration
  def change
    add_column :ticket_histories, :subscription_id, :integer
  end
end
