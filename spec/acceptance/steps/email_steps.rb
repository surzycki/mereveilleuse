module EmailSteps
  step 'there :whether_to be an email queued' do |positive|
    expectation  = positive ?  :not_to : :not

    expect(ActiveJob::Base.queue_adapter.enqueued_jobs).send expectation, be_empty
  end
end

RSpec.configure do |config|
  config.include EmailSteps 
  config.include ActiveJob::TestHelper
end