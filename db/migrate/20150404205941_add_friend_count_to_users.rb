class AddFriendCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :friend_count, :integer  
  end
end
