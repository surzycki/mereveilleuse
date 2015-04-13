module EmailSteps
  step 'there :whether_to be an email queued' do |positive|
    expectation  = positive ?  :not_to : :not

    expect(ActiveJob::Base.queue_adapter.enqueued_jobs).send expectation, be_empty
  end

  step 'a recommendation email was sent' do 
    search          = FactoryGirl.create :search
    recommendation  = FactoryGirl.create :recommendation
    email = RecommendationMailer.results(search, [recommendation] )
    email.header['skip_premailer'] = true

    email.deliver_now
    open_email(email.to.first)
  end

  step 'I click :link_id in the email' do |link_id|
    current_email.click_link link_id
  end
end

RSpec.configure do |config|
  config.include EmailSteps 
  config.include ActiveJob::TestHelper
end