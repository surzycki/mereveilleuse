class CreatePatientTypesRecommendations < ActiveRecord::Migration
  def change
    create_table :patient_types_recommendations, id: false do |t|
      t.belongs_to :patient_type,   index: true
      t.belongs_to :recommendation, index: true
    end
  end
end
