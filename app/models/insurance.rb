class Insurance < ActiveRecord::Base
  has_and_belongs_to_many :practitioners
end
