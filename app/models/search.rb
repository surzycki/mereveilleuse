class Search < ActiveRecord::Base
  store :settings, accessors: [ :sent_practitioners ], coder: JSON

  after_initialize :set_hash

  has_one    :location, dependent: :destroy, as: :locatable
  belongs_to :user

  has_and_belongs_to_many :patient_types, join_table: 'searches_patient_types', dependent: :destroy
  has_and_belongs_to_many :professions,   join_table: 'searches_professions',   dependent: :destroy

  enum status: [ :active, :canceled ]

  delegate :address,   to: :location, prefix: false, allow_nil: true
  delegate :longitude, to: :location, prefix: false, allow_nil: true
  delegate :latitude,  to: :location, prefix: false, allow_nil: true

  private
  def set_hash

  end
end
