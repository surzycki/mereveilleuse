class Occupation < ActiveRecord::Base
  belongs_to :profession
  belongs_to :practitioner

  delegate :name, to: :profession, prefix: false, allow_nil: true
end
