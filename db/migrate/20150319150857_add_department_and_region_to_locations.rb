class AddDepartmentAndRegionToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :department, :string
    add_column :locations, :region,     :string
  end
end
