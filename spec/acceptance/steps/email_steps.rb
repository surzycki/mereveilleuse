module EmailSteps
  step 'I open email sent to :recipient' do |recipient|
    open_email(recipient)
  end

  step 'I click :id in the email' do |id|
    current_email.click_link id
  end

  step 'I :whether_to see :text in the subject line' do |positive, text|
    expectation = positive ? :to : :not_to
    expect(current_email.subject).send expectation, include(text)
  end
end

RSpec.configure do |config|
  config.include EmailSteps 
  config.include ActiveJob::TestHelper
end