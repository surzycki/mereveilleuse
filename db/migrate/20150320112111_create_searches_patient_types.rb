class CreateSearchesPatientTypes < ActiveRecord::Migration
  def change
    create_table :searches_patient_types, id: false do |t|
      t.belongs_to :search,         index: true
      t.belongs_to :patient_type,   index: true
    end
  end
end
