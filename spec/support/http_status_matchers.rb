# Http status
RSpec::Matchers.define :be_created do |expected|
  match do |actual|
    actual == 201
  end
end

RSpec::Matchers.define :be_unprocessable_entity do |expected|
  match do |actual|
    actual == 422
  end
end

RSpec::Matchers.define :be_unauthorized do |expected|
  match do |actual|
    actual == 401
  end
end

RSpec::Matchers.define :be_forbidden do |expected|
  match do |actual|
    actual == 403
  end
end

RSpec::Matchers.define :be_internal_server_error do |expected|
  match do |actual|
    actual == 500
  end
end

RSpec::Matchers.define :be_json do |expected|
  match do |actual|
    (actual.header['Content-Type']).include? 'application/json'
  end
end