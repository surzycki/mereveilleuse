class AddSettingsToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :settings, :text 
  end
end
