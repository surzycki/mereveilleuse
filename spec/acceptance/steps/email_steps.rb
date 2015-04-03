module EmailSteps
  step 'there :whether_to be an email queued' do |positive|
    expectation  = positive ?  :not_to : :not

    expect(ActiveJob::Base.queue_adapter.enqueued_jobs).send expectation, be_empty
  end

  #step 'I submit the form that triggers an email' do
  #  perform_enqueued_jobs do
  #    find(:xpcurrent_userath, '//input[@type="submit"]').click
  #  #sleep 3
  #    byebug 
  #  end
  #  
  #  i = 10
  #end

  #step 'an email was sent to the current user' do
  #  
  #  user = User.first
  #  byebug
  #  open_email(user.email)
  #end
end

RSpec.configure do |config|
  config.include EmailSteps 
  config.include ActiveJob::TestHelper
end