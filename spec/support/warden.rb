module RequestHelpers
  include Warden::Test::Helpers
  Warden.test_mode!

  def integration_sign_in(account, scope = :user)
    login_as account, scope: scope
  end
end


RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end