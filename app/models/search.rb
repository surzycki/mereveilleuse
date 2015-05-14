class Search < ActiveRecord::Base
  include LocationAttributes
  include Links

  store :settings, accessors: [ :sent_practitioners ], coder: JSON

  after_validation :set_md5_hash

  uris :unsubscribe_search

  belongs_to :user

  has_and_belongs_to_many :patient_types, join_table: 'searches_patient_types'
  has_and_belongs_to_many :professions,   join_table: 'searches_professions'

  enum status: [ :active, :canceled ]

  def profession_name
    Maybe(professions.first).name._
  end

  def patient_type_name
    Maybe(patient_types.first).name._
  end

  def patient_type_id
    Maybe(patient_types.first).id._
  end

  def to_s
    "Search for #{Maybe(self).profession_name._} in #{Maybe(self).short_address._}"
  end

  def unsubscribe_search_parameterize
    { token: self.user.login_token, id: self.id }
  end

  private
  def set_md5_hash
    self.md5_hash = Digest::MD5.hexdigest(
      "#{self.status}-#{self.patient_types.map(&:id)}-#{self.professions.map(&:id)}-#{self.address}-#{self.user.try(:id)}"
    ) rescue nil
  end
end
