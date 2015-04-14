module UnsubscribeSteps
  step 'I :whether_to on the unsubscribe from search page location' do |positive|
    expectation = positive ? :to : :not_to

    search = Search.first
    user   = search.user
    url    = unsubscribe_search_path(user.login_token,search)

    expect(current_path).send expectation, eq(url)
  end
end

RSpec.configure do |config|
  config.include UnsubscribeSteps 
end