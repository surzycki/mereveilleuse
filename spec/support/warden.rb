module RequestHelpers
  include Warden::Test::Helpers
  Warden.test_mode!

  def integration_sign_in(account, scope = :user)
    login_as account, scope: scope
  end
end

module SignInHelpers
  # If we don't need all the overhead of signing we can
  # bypass much of the signin logic and stub the login
  def stubbed_sign_in(resource = double('resource'))
    allow_message_expectations_on_nil()
    
    resource_name = resource.class.name.downcase

    if resource.nil?
      allow(request.env['warden']).to receive(:authenticate!)
        .and_throw(:warden, scope: :resource)

      allow(request.env['warden']).to receive(:authenticated?)
        .and_return(false)
      
      allow(controller).to receive("current_#{resource_name}")
        .and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!)
        .and_return(resource)
      
      allow(controller).to receive("current_#{resource_name}")
        .and_return(resource)

      allow(request.env['warden']).to receive(:authenticated?)
        .and_return(true)
    end
  end
end


RSpec.configure do |config|
  config.include SignInHelpers,  type: :controller
  config.include RequestHelpers, type: :request
  config.include RequestHelpers, type: :acceptance, file_path: %r(spec/acceptance)
end