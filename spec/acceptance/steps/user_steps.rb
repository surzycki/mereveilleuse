module UserSteps
  step 'a user :fullname exists' do |fullname|
    @user = FactoryGirl.create :user, status: User.statuses[:unregistered] 
    @user.fullname = fullname
    @user.save
  end

  step 'I am :status' do |status|
    @user = User.first
    @user.send "#{status}!"
  end
end

RSpec.configure do |config|
  config.include UserSteps 
end