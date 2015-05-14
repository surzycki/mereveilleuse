class User < ActiveRecord::Base
  include PersonNameAttributes
  include LocationAttributes
  include Links

  uris :unsubscribe_account

  before_create :generate_login_token
  
  has_many :searches, dependent: :destroy

  has_many :recommendations, dependent: :destroy
  has_many :referals, through: :recommendations, source: :practitioner

  enum status:   [ :unregistered, :registered, :unsubscribed ] 
  enum platform: [ :canvas, :web ]

  def self.authenticate_with_token(token)
    find_by(login_token: token)
  end

  def generate_login_token
    self.login_token ||= SecureRandom.urlsafe_base64(15).tr('lIO0', 'sxyz')
  end

  def unsubscribe_account_parameterize
    { token: self.login_token }
  end
end
