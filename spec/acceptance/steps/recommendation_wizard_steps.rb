module RecommendationWizardSteps
  step 'recommendation wizard :step is complete' do |step|
    FactoryGirl.create :recommendation, "#{underscoreize(step)}_complete".to_sym 
  end

  step 'a practitioner :fullname exists' do |fullname|
    @practitioner = FactoryGirl.create :practitioner
    @practitioner.fullname = fullname
    @practitioner.save
  end

  step 'I am on recommendation :page' do |page|
    path = case page
    when 'step one'
      new_recommendation_path
    when 'step two'
      @recommendation = FactoryGirl.create :recommendation, :step_two
      edit_recommendation_path(@recommendation)
    when 'completed'
      @recommendation = FactoryGirl.create :recommendation, :completed
      recommendation_path(@recommendation)
    else
      root_path
    end

    visit path
  end

  step 'I :whether_to be on recommendation :page' do |positive, page|
    expectation = positive ? :to : :not_to

    path = case page
    when 'step one'
      new_recommendation_path
    when 'step two'
      edit_recommendation_path(Recommendation.first || 1)
    when 'completed'
      recommendation_path(Recommendation.first || 1)
    else
      root_path
    end

    expect(current_path).send expectation, eq(path)
  end

  step 'the practitioner :fullname address is :address' do |fullname, address|
    practitioner = Practitioner.find_by_fullname fullname
    expect(practitioner.address).to eq address
  end
end

RSpec.configure do |config|
  config.include RecommendationWizardSteps 
end