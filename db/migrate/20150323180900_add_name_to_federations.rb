class AddNameToFederations < ActiveRecord::Migration
  def change
    add_column :federations, :name, :string
  end
end
