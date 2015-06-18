class RegistrationForm
  include ActiveModel::Model
  
  attr_accessor :provider, :uid, :info, :credentials, :extra

  validates :provider, :uid, :info, presence: true 

  def user
    @user ||= User.find_by(facebook_id: uid) || create_user
  end
  
  def process   
    if self.valid?
      update_user_data
      user.registered!
      user.save
    else
      false
    end
  end

  def friend_count
    extra.try(:raw_info).try(:friends).try(:summary).try(:total_count)
  end

  private
  # isolate update of address in case address not found error.  
  def update_user_data
    user.update(
      address: info.location,
      profile_image: info.try(:image),
      friend_count:  friend_count
    )
  rescue NameError => error
  end

  def create_user
    User.new({
      facebook_id:   uid,
      firstname:     info.try(:first_name),
      lastname:      info.try(:last_name),
      email:         info.try(:email),
      profile_image: info.try(:image),
      verified:      info.try(:verified),
      friend_count:  friend_count
    })
  end
end