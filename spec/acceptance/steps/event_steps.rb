module EventSteps
  step 'the Facebook conversion pixel :whether_to be fired' do |positive|
    expectation = positive ? :to : :not_to
    text = 'Facebook Conversion Code for Affichage page reco'
    expect(page.body).send expectation, include(text)
  end
end

RSpec.configure do |config|
  config.include EventSteps 
end