module HelperSteps
   step 'show page' do
    save_page
  end

  step 'take a screenshot' do 
    screenshot
  end

  step 'I debug' do
    byebug
  end

  step 'there :whether_to be an email of type :email_type queued' do |positive, email_type|
    expectation  = positive ?  :not_to : :to 
    email_type = "#{email_type.downcase.tr(' ', '_')}"

    expect(active_job_find_by_arg(email_type)).send expectation, be_empty
  end

  step 'there :whether_to be a :job_type queued' do |positive, job_type|
    expectation  = positive ?  :not_to : :to 
 
    job_type = "#{job_type.downcase.tr(' ', '_')}_job".camelize
    
    expect(active_job_find(job_type)).send expectation, be_empty
  end

  def active_job_find(object_name)
    ActiveJob::Base.queue_adapter.enqueued_jobs.select do |item|
      item[:job].to_s == object_name
    end
  end

  def active_job_find_by_arg(argument_name)
    ActiveJob::Base.queue_adapter.enqueued_jobs.select do |item|
      item[:args].select do |arg|
        arg == argument_name
      end.present?
    end
  end
end

placeholder :whether_to do
  match /should not/ do
    false
  end

  match /should/ do
    true
  end
end

RSpec.configure do |config| 
  config.include RequestHelpers
  config.include HelperSteps
end