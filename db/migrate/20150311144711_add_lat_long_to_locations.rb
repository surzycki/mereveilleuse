class AddLatLongToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :latitude,  :float, default: 0
    add_column :locations, :longitude, :float, default: 0
  end
end
