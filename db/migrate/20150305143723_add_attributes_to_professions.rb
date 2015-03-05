class AddAttributesToProfessions < ActiveRecord::Migration
  def change
    add_column :professions, :name, :string  
  end
end
