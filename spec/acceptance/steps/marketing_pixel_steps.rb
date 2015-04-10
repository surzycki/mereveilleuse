module MarketingPixelSteps
  step 'the Facebook :pixel_type conversion pixel :whether_to be fired' do |pixel_type, positive|
    expectation = positive ? :to : :not_to
    text = "facebook conversion code for #{pixel_type.downcase}"
    
    expect(page.body).send expectation, include(text)
  end
end

RSpec.configure do |config|
  config.include MarketingPixelSteps 
end