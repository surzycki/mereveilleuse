class AddUnparsedAddressToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :unparsed_address, :string
  end
end
