class PatientType < ActiveRecord::Base
  store :settings, accessors: [ :search_alternatives ], coder: JSON

  has_and_belongs_to_many :searches, join_table: 'searches_patient_types'

  has_and_belongs_to_many :recommendations
end