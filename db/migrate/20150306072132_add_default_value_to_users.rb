class AddDefaultValueToUsers < ActiveRecord::Migration
  def change
    change_column :users, :has_invited, :boolean, default: false
  end
end
