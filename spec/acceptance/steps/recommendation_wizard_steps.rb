module RecommendationWizardSteps
  step 'recommendation wizard step one is complete' do
    FactoryGirl.create :recommendation, :step_one_complete
  end
end

RSpec.configure do |config|
  config.include RecommendationWizardSteps 
end