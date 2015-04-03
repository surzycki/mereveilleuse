module SearchSteps
  step 'a search service is running for recommendation' do 
    recommendation = FactoryGirl.create :recommendation
    allow(Recommendation).to receive(:search).and_return(OpenStruct.new results: [recommendation])
  end

  step 'I should be on the search success page' do
    expect(current_path).to eq(search_path)
  end
end

RSpec.configure do |config|
  config.include SearchSteps 
end