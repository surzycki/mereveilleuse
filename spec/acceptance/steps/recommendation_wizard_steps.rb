module RecommendationWizardSteps
  step 'recommendation wizard :step is complete' do |step|
    FactoryGirl.create :recommendation, "#{underscoreize(step)}_complete".to_sym 
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