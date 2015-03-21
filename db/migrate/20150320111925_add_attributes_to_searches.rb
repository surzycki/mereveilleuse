class AddAttributesToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :status,       :integer, default: 0
    add_column :searches, :information,  :text  
  end
end
