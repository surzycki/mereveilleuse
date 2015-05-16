class AddSettingsToPatientType < ActiveRecord::Migration
  def change
    add_column :patient_types, :settings, :text 
  end
end
