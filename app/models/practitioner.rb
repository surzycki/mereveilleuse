class Practitioner < ActiveRecord::Base
  after_initialize :set_uuid

  has_one   :location,    dependent: :destroy, as: :locatable

  has_many  :recommendations, dependent: :destroy
  has_many  :references, through: :recommendations, source: :user

  has_many :occupations, dependent: :destroy, autosave: true
  has_many :professions, through: :occupations

  private
  def set_uuid
    self.uuid ||= SecureRandom.uuid rescue nil
  end
end
