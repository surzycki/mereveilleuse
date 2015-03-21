class AddMd5HashToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :md5_hash, :string 
  end
end
