class AddPlatformToUsers < ActiveRecord::Migration
  def change
    add_column :users, :platform, :integer, default: 0
  end
end
