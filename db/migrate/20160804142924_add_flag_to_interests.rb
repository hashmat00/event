class AddFlagToInterests < ActiveRecord::Migration
  def change
    add_column :interests, :flag, :boolean
  end
end
