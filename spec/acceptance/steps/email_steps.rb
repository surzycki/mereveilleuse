module EmailSteps
  step 'I open email sent to :recipient' do |recipient|
    open_email(recipient)
  end

  step 'an email :whether_to have been sent to :recipient' do |positive, recipient|
    expectation = positive ? :not_to : :to
    
    open_email(recipient)

    expect(current_email).send expectation, be_nil
  end

  step 'I click :id in the email' do |id|
    current_email.click_link id
  end

  step 'I :whether_to see :text in the subject line' do |positive, text|
    expectation = positive ? :to : :not_to
    expect(current_email.subject).send expectation, include(text)
  end

  step 'I :whether_to see :text in the email' do |positive, text|
    expectation = positive ? :to : :not_to
    expect(current_email.body).send expectation, include(text)
  end
end

RSpec.configure do |config|
  config.include EmailSteps 
  config.include ActiveJob::TestHelper
end