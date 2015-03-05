class CreatePatientTypes < ActiveRecord::Migration
  def change
    create_table :patient_types do |t|

      t.timestamps null: false
    end
  end
end
