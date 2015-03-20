class Search < ActiveRecord::Base
  store :settings, accessors: [ :sent_practitioners ], coder: JSON

  has_one    :location, dependent: :destroy, as: :locatable
  belongs_to :user

  has_and_belongs_to_many :patient_types, join_table: 'searches_patient_types'
  has_and_belongs_to_many :professions,   join_table: 'searches_professions'

  enum status: [ :active, :canceled ]
end
