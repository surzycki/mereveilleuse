class AddAttributesToPatientTypes < ActiveRecord::Migration
  def change
    add_column :patient_types, :name, :string  
  end
end
