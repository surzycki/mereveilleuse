module EmailSteps
  step 'there :whether_to be a :job_type queued' do |positive, job_type|
    expectation  = positive ?  :not_to : :to 
    
    job_type = "#{job_type.downcase.tr(' ', '_')}_job".camelize
    
    expect(active_job_find(job_type)).send expectation, be_empty
  end

  step 'a recommendation email was sent' do 
    search          = FactoryGirl.create(:search)
    recommendation  = FactoryGirl.create :recommendation, recommender: search.user
    
    email = RecommendationMailer.results(search, [recommendation] )
    email.header['skip_premailer'] = true

    email.deliver_now
    open_email(email.to.first)
  end

  step 'I click :link_id in the email' do |link_id|
    current_email.click_link link_id
  end

  def active_job_find(object_name)
    ActiveJob::Base.queue_adapter.enqueued_jobs.select do |item|
      item[:job].to_s == object_name
    end
  end
end

RSpec.configure do |config|
  config.include EmailSteps 
  config.include ActiveJob::TestHelper
end