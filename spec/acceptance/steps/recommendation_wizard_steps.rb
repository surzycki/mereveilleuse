module RecommendationWizardSteps
  step 'recommendation wizard step one is complete' do
    FactoryGirl.create :recommendation, :step_one_complete
  end

  step 'a practitioner :fullname exists' do |fullname|
    @practitioner = FactoryGirl.create :practitioner
    @practitioner.fullname = fullname
    @practitioner.save
  end
end

RSpec.configure do |config|
  config.include RecommendationWizardSteps 
end