class AddIsPaidToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_paid, :boolean
  end
end
