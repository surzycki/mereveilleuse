class Search < ActiveRecord::Base
  include LocationAttributes

  store :settings, accessors: [ :sent_practitioners ], coder: JSON

  after_validation :set_md5_hash

  belongs_to :user

  has_and_belongs_to_many :patient_types, join_table: 'searches_patient_types', dependent: :destroy
  has_and_belongs_to_many :professions,   join_table: 'searches_professions',   dependent: :destroy

  enum status: [ :active, :canceled ]

  private
  def set_md5_hash
    #puts "#{self.status}-#{self.patient_types.map(&:id)}-#{self.professions.map(&:id)}-#{self.address}-#{self.user.try(:id)}"
    self.md5_hash = Digest::MD5.hexdigest(
      "#{self.status}-#{self.patient_types.map(&:id)}-#{self.professions.map(&:id)}-#{self.address}-#{self.user.try(:id)}"
    ) rescue nil
  end
end
