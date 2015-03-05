class AddAttributesToOccupations < ActiveRecord::Migration
  def change
    add_column :occupations, :experience, :integer  
  end
end
