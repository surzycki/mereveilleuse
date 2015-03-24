class AddNameToInsurances < ActiveRecord::Migration
  def change
    add_column :insurances, :name, :string
  end
end
