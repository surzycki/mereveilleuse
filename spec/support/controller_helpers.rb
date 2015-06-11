module ControllerHelpers
  def get_as_phone(path, params={})
    request.headers.merge!('HTTP_USER_AGENT' => 'iPhone')
    get path, params
  end
end

RSpec.configure do |config|
  config.include ControllerHelpers, type: :controller
end